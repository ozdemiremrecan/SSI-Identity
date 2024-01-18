import '@/styles/globals.css'
import "@/node_modules/bootstrap/dist/css/bootstrap.min.css"
import { useEffect } from 'react'
import Navbar from '@/components/Navbar'
export default function App({ Component, pageProps }) {
  useEffect(() => {
    require("@/node_modules/bootstrap/dist/js/bootstrap.bundle.min.js");
  }, []);
  return <>
  <Navbar/>
  <Component {...pageProps} />
  </>
}
