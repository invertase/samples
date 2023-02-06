import { Highlight } from 'react-instantsearch-hooks-web';
import { MovieHit } from '../types/movie';

type HitProps = {
  hit: MovieHit;
  onClick: Function;
};

type GenreProps = {
  genre?: string;
};

function GenreLabel({ genre }: GenreProps): JSX.Element {
  return <div className='genre-label'>{genre}</div>;
}

export default function MovieComponent({
  hit,
  onClick,
}: HitProps): JSX.Element {
  return (
    <div onClick={() => onClick(hit)}>
      <Highlight attribute='primaryTitle' hit={hit} />
      <p> {hit.startYear}</p>
      <div className='genres-row'>
        {hit.genres &&
          hit.genres.map((genre: string) => (
            <GenreLabel key={genre} genre={genre} />
          ))}
      </div>
    </div>
  );
}
