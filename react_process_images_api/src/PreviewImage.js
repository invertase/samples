import React from 'react';
import { builder } from '@invertase/image-processing-api';

const API_URL = `https://${process.env.REACT_APP_LOCATION}-${process.env.REACT_APP_PORIJECT_ID}.cloudfunctions.net/ext-image-processing-api-handler/process?operations=`;

export default function PreviewImage(props) {
  console.log(props.url.length);
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

function constructQuery(url) {
  var output;
  try {
    // Use the utility to build the query string, if it fails we'll catch and encode manually
    output = builder()
      .input({
        source: url,
      })
      .resize({ width: 400, height: 250 })
      .grayscale()
      .blur({ sigma: 3 })
      .text({ value: 'Invertase', font: '48px sans-serif', textColor: 'darkorange' })
      .output({
        format: 'webp',
      })
      .toEncodedString();
  } catch (error) {
    output = encodeURIComponent(
      JSON.stringify([
        { operation: 'input', type: 'url', url: url },
        { operation: 'resize', width: 400, height: 250 },
        { operation: 'grayscale' },
        { operation: 'blur', sigma: 3 },
        {
          operation: 'text',
          value: 'Invertase',
          font: '48px sans-serif',
          textColor: 'darkorange',
        },
        { operation: 'output', format: 'webp' },
      ])
    );
  }

  console.log(output);

  return output;
}
