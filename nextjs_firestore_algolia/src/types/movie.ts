import { DocumentSnapshot, SnapshotOptions } from 'firebase/firestore';
import { Hit } from 'instantsearch.js';

export class Movie {
  primaryTitle: string;
  originalTitle: string;
  genres: string[];
  startYear: number;

  constructor(
    primaryTitle: string,
    originalTitle: string,
    genres: string[],
    startYear: number
  ) {
    this.primaryTitle = primaryTitle;
    this.originalTitle = originalTitle;
    this.genres = genres;
    this.startYear = startYear;
  }
}

export type MovieHit = {
  primaryTitle: string;
  originalTitle: string;
  genres: string[];
  startYear: number;
} & Hit;

// Firestore data converter
export const movieConverter = {
  toFirestore: (movie: Movie) => {
    return {
      primaryTitle: movie.primaryTitle,
      originalTitle: movie.originalTitle,
      genres: movie.genres,
      startYear: movie.startYear,
    };
  },
  fromFirestore: (snapshot: DocumentSnapshot, options: SnapshotOptions) => {
    const data = snapshot.data(options);
    return new Movie(
      data!.primaryTitle,
      data!.originalTitle,
      data!.genres,
      data!.startYear
    );
  },
};
