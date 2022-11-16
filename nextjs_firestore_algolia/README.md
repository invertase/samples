# Search with Algolia Extension Sample

This is a sample NextJS application to demonstrate the usage of the [Search with Algolia](https://extensions.dev/extensions/algolia/firestore-algolia-search) Extension.
For a full tutorial, visit our blog post [here]().

## Getting Started

1. [Add the Search with Algolia Extension](https://console.firebase.google.com/project/_/extensions/install?ref=algolia/firestore-algolia-search) to your Firebase project.
2. Create a new Web App in the Firebase Console and copy the Firebase config [to this file](src/firebase/firebase_config.ts).
3. Add the Algolia App & Search keys to [the `.env` file](./.env).
4. Follow the [post-install instructions](https://github.com/algolia/firestore-algolia-search/blob/main/POSTINSTALL.md#run-the-script) to start importing data from Firestore to Algolia.
5. Run `npm install` to install the dependencies.
6. Finally, run `npm run dev` to start the development server.

### Movies Database

The data used in this sample is taken from [IMDB public data](https://www.imdb.com/interfaces/).
To import the data into your Firestore database, you have 2 options:
1. Follow the [Firestore import guide in GCP](https://firebase.google.com/docs/firestore/manage-data/export-import#import_all_documents_from_an_export). Find the exported collection [here](./movies_firestore_export).
2. Write a script in any language of your choice and use the Firebase Admin SDK to import the data.

    The following is a sample script to import the data into Firestore using the Python Admin SDK:

    ```python
    import json
    import firebase_admin
    from firebase_admin import credentials
    from firebase_admin import firestore

    f = open('movies_data.json')
    movies_data = json.load(f)

    # Your project's service file
    cred = credentials.Certificate('path/to/serviceAccountKey.json')
    firebase_admin.initialize_app(cred)

    db = firestore.client()

    # Reference to the movies collection
    col_ref = db.collection('movies')

    for movie in movies_data:
        doc_ref = col_ref.add(movie)
    ```

    You can find the data in the [`movies_data.json` file](./movies_data.json).

## Learn More

To learn more about the Search with Algolia Extension, take a look at the [documentation](https://extensions.dev/extensions/algolia/firestore-algolia-search).
