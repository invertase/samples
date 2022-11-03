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
 * @param {string} url The image URL to process.
 * @returns {string} The query string.
 *
 * */
function constructQuery(url) {
  var input = builder().input({ url: url });
  var output;

  if (url.startsWith('https://firebasestorage.googleapis.com/v0/b/')) {
    input = gcsUrlInput(url);
  }

  try {
    output = input
      .resize({ width: 400, height: 250 })
      .grayscale()
      .blur({ sigma: 3 })
      .text({
        value: 'Invertase',
        font: '48px sans-serif',
        textColor: 'darkorange',
      })
      .output({
        webp: true,
      })
      .toEncodedString();
  } catch (error) {
    console.error(error);
  }

  return output;
}

/**
 * Use this function to parse a GCS URL into a builder input.
 * @param {string} url The image GCS URL.
 * @returns {import('@invertase/image-processing-api').InputOptions} A builder with input options.
 */
function gcsUrlInput(url) {
  url = url.split('/o/')[1];
  if (url.includes('?alt=media&token=')) {
    url = url.split('?')[0];
  }

  return builder().input({ source: url });
}
