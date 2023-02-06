import { Component, OnInit } from '@angular/core';

import {
  AngularFirestore,
  AngularFirestoreCollection,
} from '@angular/fire/compat/firestore';

import { FormBuilder, FormGroup, Validators } from '@angular/forms';

import { Movie, Movies } from './movie';
import { MoviesService } from './movies.service';

@Component({
  selector: 'app-movies',
  templateUrl: './movies.component.html',
  providers: [MoviesService],
  styleUrls: ['./movies.component.css'],
})
export class MoviesComponent implements OnInit {
  movies: Movies | undefined;
  movieName = '';
  private moviesCollection: AngularFirestoreCollection<Movie>;

  /** Create the new movie form */
  newMovieForm!: FormGroup;

  constructor(
    private moviesService: MoviesService,
    firestore: AngularFirestore,
    private formBuilder: FormBuilder
  ) {
    // Edit to match your collection name specified in the Extension conmfiguration
    this.moviesCollection = firestore.collection('movies');
  }

  ngOnInit() {
    this.newMovieForm = this.formBuilder.group({
      name: ['', Validators.required],
    });
  }

  search(searchTerm: string) {
    if (searchTerm) {
      this.moviesService.searchMovies(searchTerm).subscribe((movies) => {
        this.movies = movies;
      });
    }

    this.movies = undefined;
  }

  async addMovie() {
    const formValue = this.newMovieForm.value as Movie;
    await this.moviesCollection.add(formValue);

    /** Reset the form */
    this.newMovieForm.reset({ name: '' });
  }
}
