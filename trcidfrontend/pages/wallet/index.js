import Card from "@/components/Card"
import useConnection from "@/hooks/useConnection"
import useContract from "@/hooks/useContract"
import { address } from "@/metadata/config"
import ABI from "@/metadata/config.json"
import Link from "next/link"
import { useEffect, useState } from "react";
export default function index() {
    const connection=useConnection();
    const contract=useContract(address,ABI.abi);
    const [toggle,setToggle]=useState(false);
    useEffect(()=>{
        if(connection.address){
            connection.connect();
        }
    },[connection.address])
    const setWallet=async(type,information)=>{
        const tx=await contract.createWallet(type,information);
        await tx.wait();
        setToggle(true);
    }
  return (
        <>
            <div className="container">
                <div className="row">
                    <div className="col-xs-12">
                        {!toggle && <div class="card w-50">
                            <h5 class="card-header">TC</h5>
                            <div class="card-body">
                                <h5 class="card-title">Special title treatment</h5>
                                <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
                                <button onClick={()=>setWallet("0",["1233123123"])} class="btn btn-primary">Read</button>
                            </div>
                        </div>}
                        {toggle&& <Card title={"Success"}/>}
                    </div>
                </div>
            </div>
        </>
    )
}
