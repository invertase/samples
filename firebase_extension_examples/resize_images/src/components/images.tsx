import { builder } from "@invertase/image-processing-api";

/** Add project config */
const PROJECT_ID = "";
const PROJECT_LOCATION = "$";

/** List names of images from a GCS source */
const imageSources = [
  {
    id: 1,
    title: "Mountains",
    //image: "travelling/pexels-amine-m'siouri-2108813.jpg",
  },

  // rest of the images
];

const getUrl = (source: string, width: number, height: number) => {
  const URL = `https://${PROJECT_LOCATION}-${PROJECT_ID}.cloudfunctions.net/ext-image-processing-api-handler/process?operations=`;

  const options = builder()
    .input({
      type: "gcs",
      source,
    })
    .resize({ width, height })
    .output({ webp: { quality: 50 } })
    .toEncodedString();

  return `${URL}${options}`;
};

const Images = () => {
  // Output the result to the page

  return (
    <div className="md:p-8">
      <div className="flex flex-wrap md:p-2">
        {imageSources.map((selection: any) => {
          return (
            <div className="p-1 md:w-1/3 lg:w-full">
              <div className="relative">
                <picture>
                  <source
                    srcSet={`${getUrl(selection.image, 200, 200)} 200w`}
                    media={`(min-width: 200px) and (max-width: 400px)`}
                    width="200px"
                    height="200px"
                  />
                  <source
                    srcSet={`${getUrl(selection.image, 400, 400)} 400w`}
                    media={`(min-width: 400px) and (max-width: 600px)`}
                    width="400px"
                    height="400px"
                  />
                  <source
                    srcSet={`${getUrl(selection.image, 600, 600)} 600w`}
                    media={`(min-width: 600px) and (max-width: 800px)`}
                    width="600px"
                    height="600px"
                  />
                  <source
                    srcSet={`${getUrl(selection.image, 800, 800)} 800w`}
                    media={`(min-width: 800px) and (max-width: 1000px)`}
                    width="800px"
                    height="800px"
                  />
                  <source
                    srcSet={`${getUrl(selection.image, 1000, 1000)} 1000w`}
                    media={`(min-width: 1200px) and (max-width: 1000px)`}
                    width="1000px"
                    height="1000px"
                  />
                  <source
                    srcSet={`${getUrl(selection.image, 1200, 1200)} 1200w`}
                    width="1200px"
                    height="1200px"
                    media={`(min-width: 1200px) `}
                  />
                  <img
                    src={getUrl(selection.image, 200, 200)}
                    className="object-cover object-center w-full h-full"
                    width="200px"
                    height="200px"
                    loading="lazy"
                  />
                </picture>
                <div className="absolute bottom-0 right-0">
                  <div className="bold text-white p-4">{selection.title}</div>
                </div>
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
};

export default Images;
