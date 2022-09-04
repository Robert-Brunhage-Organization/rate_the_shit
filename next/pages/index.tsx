import type { NextPage } from "next";
import Head from "next/head";
import styles from "../styles/Home.module.css";

const Home: NextPage = () => {
  return (
    <div className={styles.container}>
      <Head>
        <title>Rate the Shit</title>
        <meta name="description" content="Rate the Shit" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <main className={styles.main}>
        <h1 className={styles.title}>
          Welcome to the{" "}
          <a
            href="https://github.com/Robert-Brunhage-Organization/rate_the_shit"
            target="_blank"
          >
            Shit!
          </a>
        </h1>
      </main>
    </div>
  );
};

export default Home;
