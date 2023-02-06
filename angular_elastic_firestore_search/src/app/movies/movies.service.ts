import { Injectable } from '@angular/core';
import { HttpClient, HttpParams } from '@angular/common/http';
import { HttpHeaders } from '@angular/common/http';

import { Observable } from 'rxjs';
import { catchError } from 'rxjs/operators';

import { Movies } from './movie';
import { HttpErrorHandler, HandleError } from '../http-error-handler.service';

/** Add your elastic private key */
const httpOptions = {
  headers: new HttpHeaders({
    'Content-Type': 'application/json',
    Authorization: 'Bearer {private_key}',
  }),
};

/* Docs (https://docs.meilisearch.com/reference/api/search.html#search-in-an-index-with-post-route) */

@Injectable()
export class MoviesService {
  /** Add your elastic api host url */
  hostUrl = '{host_url}';
  moviesDocumentsUrl = `${this.hostUrl}/api/as/v1/engines/movies/documents/list`;
  moviesSearchUrl = `${this.hostUrl}/api/as/v1/engines/movies/search`;
  private handleError: HandleError;

  constructor(private http: HttpClient, httpErrorHandler: HttpErrorHandler) {
    this.handleError = httpErrorHandler.createHandleError('MoviesService');
  }

  /* GET Movies whose name contains search term */
  searchMovies(term: string): Observable<Movies> {
    term = term.trim();

    // Add safe, URL encoded search parameter if there is a search term
    const options = {
      params: new HttpParams().set('query', term),
    };

    return this.http
      .get<Movies>(this.moviesSearchUrl, { ...httpOptions, ...options })
      .pipe(catchError(this.handleError<Movies>('searchMovies')));
  }
}
