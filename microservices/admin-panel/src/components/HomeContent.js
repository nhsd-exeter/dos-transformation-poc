import React from 'react'
import { Link } from "react-router-dom";

export default function HomeContent() {
  return (
    <section className="container">
        <div className="columns features">
            <div className="column is-4">
                <div className="card is-shady">
                    <div className="card-content">
                        <div className="content">
                            <h4>Service Management</h4>
                            <p>Manage directory data and services more effectively.</p>
                            <p><Link to={"/servicemanagement"}>Learn More </Link></p>
                        </div>
                    </div>
                </div>
            </div>
            <div className="column is-4">
                <div className="card is-shady">
                    <div className="card-content">
                        <div className="content">
                            <h4>Profile Management</h4>
                            <p>Create, edit and maintain user search profiles and geo-profiles,</p>
                            <p><Link to={"/profilemanagement"}>Learn More </Link></p>
                        </div>
                    </div>
                </div>
            </div>
            <div className="column is-4">
                <div className="card is-shady">
                     <div className="card-content">
                        <div className="content">
                            <h4>Coming Soon</h4>
                            <p>More to be added soon...</p>
                            <p><Link to={"/"}>Learn More </Link></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
  )
}
