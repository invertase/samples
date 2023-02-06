import './App.css';
import React, { useState } from 'react';

import PreviewImage from './PreviewImage';

const images = [
  // GCS source
  'https://firebasestorage.googleapis.com/v0/b/flutter-vikings-satging.appspot.com/o/stories%2FR5jCMSdfnSE70unFfpd2.jpg?alt=media&token=5f5c7011-6852-4dd7-91f0-3bf680e27e7f',
  // HTTP source
  'https://images.pexels.com/photos/2662116/pexels-photo-2662116.jpeg',
  'https://images.pexels.com/photos/1287145/pexels-photo-1287145.jpeg',
  'https://images.pexels.com/photos/1770809/pexels-photo-1770809.jpeg',
];

export default function App() {
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
                    className={`margin border-radius animate ${
                      url === image && 'img-overlay'
                    }`}
                    onClick={() => setUrl(image)}
                  >
                    <img
                      className={`image ${url === image && 'border-radius'}`}
                      src={image}
                      alt='logo'
                    />
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
