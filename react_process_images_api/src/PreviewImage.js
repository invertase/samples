import React from 'react';
import { builder } from '@invertase/image-processing-api';

const API_URL = `https://${process.env.REACT_APP_LOCATION}-${process.env.REACT_APP_PORIJECT_ID}.cloudfunctions.net/ext-image-processing-api-handler/process?operations=`;

export default function PreviewImage(props) {
  if (props.url.length === 0) {
    return (
      <div className='image'>
        <h2>Click on any image</h2>
      </div>
    );
  }

  const query = constructQuery(props.url);

  return <img src={API_URL + query} alt={props.alt} />;
}

/**
 * Use the utility lib to build the query string.
 *
 * If you have an input from your storage bucket, you can use the following:
 * `builder().input('gs://my-bucket/my-image.jpg')`
 *
 * @param {string} url The image URL to process.
 * @returns {string} The query string.
 *
 * */
function constructQuery(url) {
  var output;
  try {
    output = builder()
      .input({
        url,
      })
      .resize({ width: 400, height: 250 })
      .grayscale()
      .blur({ sigma: 3 })
      .text({ value: 'Invertase', font: '48px sans-serif', textColor: 'darkorange' })
      .output({
        webp: true,
      })
      .toEncodedString();
  } catch (error) {
    console.error(error);
  }

  return output;
}
