import '../styles/globals.css';
import type { AppProps } from 'next/app';
import Head from 'next/head';

export default function App({ Component, pageProps }: AppProps) {
  return (
    <div>
      <Head>
        <title>Search with Algolia</title>
        <meta charSet='UTF-8' />
        <meta name='keywords' content='titla, meta, nextjs' />
        <meta name='author' content='Invertase' />
        <meta name='viewport' content='width=device-width, initial-scale=1.0' />
      </Head>
      <Component {...pageProps} />;
    </div>
  );
}
