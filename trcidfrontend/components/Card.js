import React from 'react'
import Link from 'next/link'
export default function Card(props) {
    return (
        <div class="card w-50">
            <h5 class="card-header">{props.title}</h5>
            <div class="card-body">
                <h5 class="card-title">Special title treatment</h5>
                <p class="card-text">With supporting text below as a natural lead-in to additional content.</p>
                <Link href="/" class="btn btn-primary">Go somewhere</Link>
            </div>
        </div>

    )
}
