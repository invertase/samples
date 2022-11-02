import './App.css';
import React, { useState } from 'react';

import PreviewImage from './PreviewImage';

const images = [
  'https://images.pexels.com/photos/14036566/pexels-photo-14036566.jpeg',
  'https://images.pexels.com/photos/2662116/pexels-photo-2662116.jpeg',
  'https://images.pexels.com/photos/1287145/pexels-photo-1287145.jpeg',
  'https://images.pexels.com/photos/1770809/pexels-photo-1770809.jpeg',
];

function App() {
  const [url, setUrl] = useState('');

  console.log(url);

  return (
    <body className='app'>
      <div className='app-body'>
        <div className='images'>
          <table>
            <tbody>
              {images.map((image) => (
                <td>
                  <div
                    className={`margin border-radius animate ${url === image && 'img-overlay'}`}
                    onClick={() => {
                      setUrl(image);
                    }}
                  >
                    <img className={`image ${url === image && 'border-radius'}`} src={image} alt='logo' />
                  </div>
                </td>
              ))}
            </tbody>
          </table>
        </div>
        <div className='margin h200'>
          <PreviewImage url={url} />
        </div>
      </div>
    </body>
  );
}

export default App;
