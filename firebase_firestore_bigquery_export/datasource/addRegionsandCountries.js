var admin = require("firebase-admin");
var request = require("request");

admin.initializeApp();

const countriesRegionUrl = "https://restcountries.com/v3.1/region";
const db = admin.firestore();
const regions = [
  "South America",
  "Southern Europe",
  "Central America",
  "Eastern Asia",
  "Europe",
];

(async () => {
  const regionsRef = db.collection("regions");

  for await (const region of regions) {
    const regionDoc = regionsRef.doc(region);
    await regionDoc.set({ name: region });

    await request(
      `${countriesRegionUrl}/${region}`,
      { json: true },
      async (err, res, countries) => {
        const countryRef = regionDoc.collection("countries");
        const allCountries = countries.map((c) => {
          return { name: c.name.common, population: c.population };
        });

        for await (const country of allCountries) {
          await countryRef
            .doc(country.name)
            .set({ population: country.population });
        }
      }
    );
  }
})();
