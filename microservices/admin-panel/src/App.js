import React, { Component } from 'react';
import { BrowserRouter as Router, Route, Routes } from 'react-router-dom';
import './App.css';
import Navbar from './components/Navbar';
import Home from './components/Home';
import LogIn from './components/auth/LogIn';
import ServiceManagement from './components/ServiceManagement';
import ProfileManagement from './components/ProfileManagement';
import {Auth} from 'aws-amplify'
import Footer from './components/Footer';
import { library } from '@fortawesome/fontawesome-svg-core';
import { faEdit } from '@fortawesome/free-solid-svg-icons';
library.add(faEdit);

class App extends Component {
  state = {
    isAuthenticated: false,
    isAuthenticating: true,
    user: null,
  }

  setAuthState = authenticated => {
    this.setState({isAuthenticated: authenticated})
  }
  setUser = user => {
    this.setState({user: user})
  }

  async componentDidMount() {
    try {
      const session = await Auth.currentSession()
    this.setAuthState(true)
    console.log(session);
    const user = Auth.currentAuthenticatedUser()
    this.setUser(user)
    } catch (error) {
      console.error(error)
    }
    this.setState({isAuthenticating: false})
  }

  render() {
    const authProps = {
      isAuthenticated: this.state.isAuthenticated,
      user: this.state.user,
      setAuthState: this.setAuthState,
      setUser: this.setUser
    }
    return (
      !this.state.isAuthenticating &&
      <div className="App">
        <Router>
          <div>
            <Navbar auth={authProps} />
            <Routes>
              <Route path="/" element={<Home auth={authProps} />} />   
              <Route path="/login" element={<LogIn auth={authProps} />} /> 
              <Route path="/servicemanagement" element={<ServiceManagement auth={authProps} />} /> 
              <Route path="/profilemanagement" element={<ProfileManagement auth={authProps} />} /> 
            </Routes>
            <Footer />
          </div>
        </Router>
      </div>
    );
  }
}

export default App;
