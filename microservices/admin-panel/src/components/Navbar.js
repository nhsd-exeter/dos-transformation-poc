import { Auth } from 'aws-amplify';
import React, { Component } from 'react'
import { Link } from "react-router-dom";

export default class Navbar extends Component {
  handleLogout = async event => {
    event.preventDefault()
    try {
      Auth.signOut()
      this.props.auth.setAuthState(false)
      this.props.auth.setUser(null)
    } catch (error) {
      console.error(error);
    }
  }
  render() {
    return (
      <nav className="navbar" role="navigation" aria-label="main navigation">
        <div className="navbar-brand">
          <a className="navbar-item" href="/">
            <img src="logo.png" width="70" height="28" alt="logo" />
          </a>
        </div>

        <div id="navbarBasicExample" className="navbar-menu">
          <div className="navbar-start">
            <div className="navbar-item">
              <Link to={"/"}>Home </Link>
            </div>
            <div className="navbar-item">
              <Link to={"/servicemanagement"}>Service Management </Link>
            </div>
            <div className="navbar-item">
              <Link to={"/profilemanagement"}>Profile Management </Link>
            </div>
          </div>

          <div className="navbar-end">
            <div className="navbar-item">
              {this.props.auth.isAuthenticated && this.props.auth.user && (
                <p>Hello {this.props.auth.user.username}</p>
              )}
              <div className="buttons">
                {!this.props.auth.isAuthenticated && (
                  <div>
                  <a href="/login" className="button is-light">
                    Log in
                  </a>
                </div>
                )}
                {this.props.auth.isAuthenticated && (
                  <a href="/" onClick={this.handleLogout} className="button is-light">
                  Log out
                </a>
                )}
              </div>
            </div>
          </div>
        </div>
      </nav>
    )
  }
}
