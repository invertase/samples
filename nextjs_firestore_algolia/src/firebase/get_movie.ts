import { initializeApp } from 'firebase/app';
import { getFirestore } from 'firebase/firestore';
import { firebaseConfig } from './firebase_config';
import { getDoc, doc } from 'firebase/firestore';
import { movieConverter } from '../types/movie';

// Data used in this sample is taken from https://www.imdb.com/interfaces/

const app = initializeApp(firebaseConfig);
const firestore = getFirestore(app);

export async function getMovieDoc(movieId: string) {
  const ref = doc(firestore, `movies/${movieId}`).withConverter(movieConverter);
  const docSnap = await getDoc(ref);

  if (docSnap.exists()) {
    return docSnap.data();
  } else {
    console.error('No such document!');
  }
}
