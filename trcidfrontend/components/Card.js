import React from 'react'
import { useRouter } from 'next/router'
export default function Card(props) {
    const router=useRouter();
    return (
        <div class="card w-50">
            <h5 class="card-header">{props.title}</h5>
            <div class="card-body">
                <h5 class="card-title">Special title treatment</h5>
                <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
                <button type='button' onClick={()=>router.push("/")} class="btn btn-primary">Return mainpage</button>
            </div>
        </div>

    )
}
