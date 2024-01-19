import React from 'react'
import { useEffect,useState } from 'react'
import useConnection from '@/hooks/useConnection'
import useContract from '@/hooks/useContract'
import { address } from '@/metadata/config'
import ABI from '@/metadata/config.json'
export default function index() {
    const connection=useConnection();
    const contract=useContract(address,ABI.abi);
    const [toggle,setToggle]=useState();
    useEffect(()=>{
        if(connection.address){
            connection.connect();
        }
    },[connection.address])
    const setIdKey=async()=>{
        const tx=await contract.writeBlockchain();
        await tx.wait();
        setToggle(true);
    }
  return (
    <>
        <div className='container'>
            <div className='row'>
                <div className='col-xs-12'>
                    {!toggle&&<div class="card w-50 mt-5">
                        <h5 class="card-header">Action</h5>
                        <div class="card-body">
                            <h5 class="card-title"></h5>
                            <p class="card-text">Write blockchain to datas</p>
                            <button type='button' onClick={()=>setIdKey} class="btn btn-primary">Write</button>
                        </div>
                    </div>}
                    {toggle&& <Card title={"Success"}/>}
                </div>
            </div>
        </div>
    </>
  )
}
