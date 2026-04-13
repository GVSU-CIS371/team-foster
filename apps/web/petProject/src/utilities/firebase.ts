// Import the functions you need from the SDKs you need
import { initializeApp } from "firebase/app";
import { getAuth } from 'firebase/auth'
import { getFirestore } from 'firebase/firestore'
// TODO: Add SDKs for Firebase products that you want to use
// https://firebase.google.com/docs/web/setup#available-libraries

// Your web app's Firebase configuration
const firebaseConfig = {
  apiKey: "AIzaSyAnHblEyOUtbKObkoeAiHBpub1dxyZHvGA",
  authDomain: "petproject-e2e67.firebaseapp.com",
  projectId: "petproject-e2e67",
  storageBucket: "petproject-e2e67.firebasestorage.app",
  messagingSenderId: "338530244343",
  appId: "1:338530244343:web:1b3d0883a8ac1739b565f2"
};



// Initialize Firebase
const app = initializeApp(firebaseConfig);

export const auth = getAuth(app)
export const db = getFirestore(app)

export default app