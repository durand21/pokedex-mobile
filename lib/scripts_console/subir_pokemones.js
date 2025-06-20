const fetch = (...args) => import('node-fetch').then(({ default: fetch }) => fetch(...args));
const admin = require('firebase-admin');
const serviceAccount = require('mi clave de servicio.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: serviceAccount.project_id, // << Esto es clave
});

const db = admin.firestore();

async function subirPokemones() {
  const countRes = await fetch('https://pokeapi.co/api/v2/pokemon?limit=1');
  const totalCount = (await countRes.json()).count;

  console.log('Total de pokemones:', totalCount);

  const res = await fetch(`https://pokeapi.co/api/v2/pokemon?limit=${totalCount}`);
  const data = await res.json();

  for (const poke of data.results) {
    const detail = await fetch(poke.url);
    const detailData = await detail.json();

    const types = detailData.types.map(t => t.type.name);

    await db.collection('pokemones').doc(poke.name).set({
      name: poke.name,
      url: poke.url,
      types: types,
    });

    console.log(`✅ Subido: ${poke.name}`);
    await new Promise(r => setTimeout(r, 100));
  }

  console.log('✔ Carga completa');
}

subirPokemones().catch(console.error);
