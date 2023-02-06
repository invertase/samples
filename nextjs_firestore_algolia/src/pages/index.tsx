import { useEffect, useState } from 'react';

import algoliasearch from 'algoliasearch/lite';
import {
  InstantSearch,
  SearchBox,
  RefinementList,
  InfiniteHits,
} from 'react-instantsearch-hooks-web';
import type { Hit } from 'instantsearch.js';

import MovieComponent from '../components/hit';
import { MovieHit } from '../types/movie';
import { getMovieDoc } from '../firebase/get_movie';

const searchClient = algoliasearch(
  process.env.NEXT_PUBLIC_ALGOLIA_APP_ID!,
  process.env.NEXT_PUBLIC_ALGOLIA_SEARCH_KEY!
);

export default function Home() {
  const [selectedMovie, setSelectedMovie] = useState<MovieHit | undefined>();

  const MovieHitComponent = ({ hit }: { hit: Hit<MovieHit> }) => {
    return <MovieComponent hit={hit} onClick={setSelectedMovie} />;
  };

  useEffect(() => {
    if (selectedMovie) {
      getMovieDoc(selectedMovie.objectID).then((movie) => {
        console.log(movie);
      });
    }
  }, [selectedMovie]);

  return (
    <div className='container'>
      <InstantSearch searchClient={searchClient} indexName='movies'>
        <div className='container-search-hits'>
          <SearchBox placeholder='Search for movies' />
          <InfiniteHits hitComponent={MovieHitComponent} />
        </div>
        <RefinementList attribute='genres' />
      </InstantSearch>
    </div>
  );
}
