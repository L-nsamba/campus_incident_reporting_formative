
const fs = require("fs");
const path = require("path");

const {
  initializeTestEnvironment,
  assertSucceeds,
  assertFails,
} = require("@firebase/rules-unit-testing");

const {
  collection,
  doc,
  getDocs,
  setDoc,
  updateDoc,
  writeBatch,
  Timestamp,
} = require("firebase/firestore");

let testEnv;

const studentUid = "student-123";
const otherStudentUid = "student-456";
const staffUid = "staff-123";

const now = Timestamp.now();

function incidentData(reporterId = studentUid) {
  return {
    reporterId,
    title: "Broken classroom chair",
    description: "A chair is damaged in the classroom.",
    category: "furniture",
    location: "Classroom",
    status: "submitted",
    photoUrl: null,
    createdAt: now,
    updatedAt: now,
  };
}

async function seedIncident(incidentId = "incident-123") {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    await setDoc(
      doc(context.firestore(), "incidents", incidentId),
      incidentData()
    );
  });
}

async function seedStaffProfile() {
  await testEnv.withSecurityRulesDisabled(async (context) => {
    await setDoc(doc(context.firestore(), "users", staffUid), {
      name: "Test Staff",
      email: "staff@example.com",
      role: "staff",
      createdAt: now,
      updatedAt: now,
    });
  });
}

beforeAll(async () => {
  testEnv = await initializeTestEnvironment({
    projectId: "campusincidentreporter",
    firestore: {
      rules: fs.readFileSync(
        path.resolve(__dirname, "../firestore.rules"),
        "utf8"
      ),
      host: "127.0.0.1",
      port: 8080,
    },
  });
});

beforeEach(async () => {
  await testEnv.clearFirestore();
});

afterAll(async () => {
  await testEnv.cleanup();
});

describe("Firestore security rules", () => {
  test("SEC-01: Unauthenticated users cannot read incidents", async () => {
    const db = testEnv.unauthenticatedContext().firestore();

    await assertFails(
      getDocs(collection(db, "incidents"))
    );
  });

  test("SEC-02: Students can create their own incident and initial history", async () => {
    const db = testEnv.authenticatedContext(studentUid).firestore();

    const incidentRef = doc(db, "incidents", "incident-123");
    const historyRef = doc(
      db,
      "incidents",
      "incident-123",
      "statusHistory",
      "history-1"
    );

    const batch = writeBatch(db);

    batch.set(incidentRef, incidentData(studentUid));

    batch.set(historyRef, {
      status: "submitted",
      updatedBy: studentUid,
      note: "",
      createdAt: now,
    });

    await assertSucceeds(batch.commit());
  });

  test("SEC-03: Students cannot submit incidents using another user's UID", async () => {
    const db = testEnv.authenticatedContext(studentUid).firestore();

    await assertFails(
      setDoc(
        doc(db, "incidents", "incident-123"),
        incidentData(otherStudentUid)
      )
    );
  });

  test("SEC-04: Students cannot update incident statuses", async () => {
    await seedIncident();

    const db = testEnv.authenticatedContext(studentUid).firestore();

    await assertFails(
      updateDoc(doc(db, "incidents", "incident-123"), {
        status: "inReview",
        updatedAt: Timestamp.now(),
      })
    );
  });

  test("SEC-05: Staff can advance an incident to the next status", async () => {
    await seedIncident();
    await seedStaffProfile();

    const db = testEnv.authenticatedContext(staffUid).firestore();

    const incidentRef = doc(db, "incidents", "incident-123");
    const historyRef = doc(
      db,
      "incidents",
      "incident-123",
      "statusHistory",
      "history-2"
    );

    const batch = writeBatch(db);

    batch.update(incidentRef, {
      status: "inReview",
      updatedAt: Timestamp.now(),
    });

    batch.set(historyRef, {
      status: "inReview",
      updatedBy: staffUid,
      note: "Report reviewed.",
      createdAt: Timestamp.now(),
    });

    await assertSucceeds(batch.commit());
  });

  test("SEC-06: Staff cannot skip incident status stages", async () => {
    await seedIncident();
    await seedStaffProfile();

    const db = testEnv.authenticatedContext(staffUid).firestore();

    await assertFails(
      updateDoc(doc(db, "incidents", "incident-123"), {
        status: "resolved",
        updatedAt: Timestamp.now(),
      })
    );
  });
});
