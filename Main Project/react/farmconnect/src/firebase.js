// src/firebase.js
import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';

const firebaseConfig = {
  apiKey: "AIzaSyBCfDYa-Fyu8l7H1fuX0Id4d0asR4AImpI",
  authDomain: "flutter-firebase-3fd58.firebaseapp.com",
  projectId: "flutter-firebase-3fd58",
  storageBucket: "flutter-firebase-3fd58.appspot.com",
  messagingSenderId: "293890017069",
  appId: "1:293890017069:web:50e84384d8e8739c69b5a4"
};

const app = initializeApp(firebaseConfig);
const firestore = getFirestore(app);

export default firestore;
