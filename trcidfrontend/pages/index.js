import Card from "@/components/Card";
import useConnection from "@/hooks/useConnection"
import { useRouter } from "next/router";
import { useEffect } from "react";
import Link from "next/link";
export default function Home() {
  const router=useRouter();
  const connection=useConnection();
  useEffect(()=>{
    if(connection.address){
      connection.connect();
    }
  },[connection.address])
  return (
    <>
      <div className="container">
        <div className="row">
          <div className="col-xs-12">
              <div class="card w-50 mt-5">
                <div class="card-body m-5">
                    <Link href="/wallet" class="btn btn-primary">Go Wallet</Link>
                </div>
            </div>
          </div>
        </div>
      </div>
    </>
  )
}
