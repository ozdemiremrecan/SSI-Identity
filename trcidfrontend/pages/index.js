import Card from "@/components/Card";
import useConnection from "@/hooks/useConnection"
import { useEffect } from "react";

export default function Home() {
  const connection=useConnection();
  useEffect(()=>{
    connection.connect();
  },[connection.address])
  return (
    <>
      <div className="container">
        <Card title={"Success"}/>
      </div>
    </>
  )
}
