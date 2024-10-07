const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Cloud Function to set custom claims for an admin
exports.setAdminRole = functions.https.onCall(async (data, context) => {
  // Check if the request is authenticated
  if (!context.auth) {
    throw new functions.https.HttpsError(
        "failed-precondition",
        "The function must be called while authenticated.",
    );
  }

  const email = data.email; // Email of the user to set as admin
  try {
    // Get the user by email
    const user = await admin.auth().getUserByEmail(email);

    // Set custom user claims
    await admin.auth().setCustomUserClaims(user.uid, {
      role: "admin",
    });

    return {
      message: `Success! ${email} has been assigned the admin role.`,
    };
  } catch (error) {
    // Handle errors like user not found
    throw new functions.https.HttpsError(
        "internal",
        `Error assigning admin role: ${error.message}`,
    );
  }
});
