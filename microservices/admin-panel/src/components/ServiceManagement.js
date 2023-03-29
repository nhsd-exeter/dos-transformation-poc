import React, { Fragment, Component } from 'react';
import { Navigate } from 'react-router-dom';
import axios from 'axios';
import Accordion from '@mui/material/Accordion';
import AccordionSummary from '@mui/material/AccordionSummary';
import AccordionDetails from '@mui/material/AccordionDetails';
import Typography from '@mui/material/Typography';
import ExpandMoreIcon from '@mui/icons-material/ExpandMore';
import Table from '@mui/material/Table';
import TableBody from '@mui/material/TableBody';
import TableCell from '@mui/material/TableCell';
import TableContainer from '@mui/material/TableContainer';
import TableRow from '@mui/material/TableRow';
import Paper from '@mui/material/Paper';
import Container from '@mui/material/Container';
import GoogleMapReact from 'google-map-react'
import { Icon } from '@iconify/react'
import locationIcon from '@iconify/icons-mdi/map-marker';
import Grid from '@mui/material/Grid';
import { styled } from '@mui/material/styles';

//ICON IMPORTS
import LocationCityIcon from '@mui/icons-material/LocationCity';
import RoomIcon from '@mui/icons-material/Room';
import DriveFileRenameOutlineIcon from '@mui/icons-material/DriveFileRenameOutline';
import CategoryIcon from '@mui/icons-material/Category';
import BadgeIcon from '@mui/icons-material/Badge';
import CheckCircleOutlineIcon from '@mui/icons-material/CheckCircleOutline';
import NotListedLocationIcon from '@mui/icons-material/NotListedLocation';
import BusinessIcon from '@mui/icons-material/Business';
import TravelExploreIcon from '@mui/icons-material/TravelExplore';
import AccessTimeIcon from '@mui/icons-material/AccessTime';
import LocalPhoneIcon from '@mui/icons-material/LocalPhone';
import AccountTreeIcon from '@mui/icons-material/AccountTree';


class ServiceManagement extends Component {
  constructor () {
    super()
    this.state = { currentService: null }
  }

  componentDidMount() {
    this.getService()
      .then(result => this.setState({ currentService: result }) )
  }

  getService = async () =>
  {
    console.log( this.props.auth.user.token)
    const APIGateway = axios.create({
      baseURL: 'https://ar7kwintik.execute-api.eu-west-2.amazonaws.com/main/services',
      timeout: 3000,
      headers: {
        "Authorization": this.props.auth.user.token,
        "Access-Control-Allow-Origin": "https://localhost", 
        "Content-Type": "application/json"
      }
    });

    const {request} = await APIGateway.get();
    const parsedResponse= await JSON.parse(request.response);
    let service = await parsedResponse.body;

    return service;

  }


  render(){

    if(!this.state.currentService){
      return (<Fragment>{!this.props.auth.isAuthenticated && <Navigate to='/login' replace={true}/> }</Fragment>)}

    const serviceLocation = {
      center: {
        lat: this.state.currentService.location[0].position.latitude,
        lng: this.state.currentService.location[0].position.longitude
      },
      zoom: 14
    };

    const Item = styled(Paper)(({ theme }) => ({
      backgroundColor: theme.palette.mode === 'dark' ? '#1A2027' : '#fff',
      ...theme.typography.body2,
      padding: theme.spacing(1),
      textAlign: 'left',
      color: theme.palette.text.secondary,
    }));

    const LocationPin = () => (
      <div className="pin">
        <Icon icon={locationIcon} className="pin-icon" />
      </div>
    )

    const handleCoverageMapLoaded = (map, maps) => {
      const coordinates = this.state.currentService.coverageArea[0].position.coordinates[0];

      let polygon = []
      for (const i in coordinates)
      {
        polygon[i] = {lat: coordinates[i][1], lng: coordinates[i][0]}
      }
    
      var coverageArea = new maps.Polygon({
        paths: polygon,
        strokeColor: "#FF0000",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#7FFFD4",
        fillOpacity: 0.25
      });
      coverageArea.setMap(map);
    }

    return (
      <Fragment>
        {!this.props.auth.isAuthenticated && <Navigate to='/login' replace={true}/> }
        <div className="box cta">
          <p className="has-text-centered">
            <span className="tag is-primary">Service Management</span> Manage services</p>
        </div>

<Container maxWidth="lg">
  <div>
    <h1>{this.state.currentService.name}</h1>
  </div>
  <div>
  <Grid container spacing={2}>
    <Grid item xs={8}>
      <Item>
        <b>General Service Data</b>
      <TableContainer component={Paper}>
        <Table sx={{ minWidth: 500 }} aria-label="custom pagination table">
          <TableBody>
              <TableRow>
              <TableCell style={{ width: 100 }} align="left">
                <p><DriveFileRenameOutlineIcon/></p>
              </TableCell>
                <TableCell component="th" scope="row">
                  <p><b>Name</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  {this.state.currentService.name}
                </TableCell>
              </TableRow>
              <TableRow>
              <TableCell style={{ width: 100 }} align="left">
                <p><BadgeIcon/></p>
              </TableCell>
                <TableCell component="th" scope="row">
                  <p><b>Service Type</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  {this.state.currentService.type}
                </TableCell>
              </TableRow>
              <TableRow>
              <TableCell style={{ width: 100 }} align="left">
                <p><CategoryIcon/></p>
              </TableCell>
                <TableCell component="th" scope="row">
                  <p><b>Service Category</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  {this.state.currentService.category}
                </TableCell>
              </TableRow>
              <TableRow>
              <TableCell style={{ width: 100 }} align="left">
                <p><CheckCircleOutlineIcon/></p>
              </TableCell>
                <TableCell component="th" scope="row">
                  <p><b>Active Status</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  {this.state.currentService.active? <span className="tag is-primary">Active</span> : <span className="tag is-warning">Inactive</span> }
                </TableCell>
              </TableRow>
          </TableBody>
        </Table>
      </TableContainer>
      </Item>
    </Grid>
    <Grid item xs={4}>
      <Item>
      <div style={{ height: '30vh', width: '100%' }}>
        <GoogleMapReact
          defaultCenter={serviceLocation.center}
          defaultZoom={serviceLocation.zoom}
        >
        <LocationPin
            lat={this.state.currentService.location[0].position.latitude}
            lng={this.state.currentService.location[0].position.longitude}
          />
        </GoogleMapReact>
      </div>
      </Item>
    </Grid>

  </Grid>
  <Grid container spacing={2}>
          <Grid item xs={12}>
            <Item>

            <Accordion>
          <AccordionSummary
            expandIcon={<ExpandMoreIcon />}
            aria-controls="panel1a-content"
            id="panel1a-header"
          >
            <Typography><b>Location Data</b></Typography>
          </AccordionSummary>
          <AccordionDetails>
            <Typography>
            <TableContainer component={Paper}>
        <Table sx={{ minWidth: 500 }} aria-label="custom pagination table">
          <TableBody>
              <TableRow>
              <TableCell style={{ width: 100 }} align="left">
                <p><DriveFileRenameOutlineIcon/></p>
              </TableCell>
                <TableCell component="th" scope="row">
                  <p><b>Location Name</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  {this.state.currentService.location[0].name}
                </TableCell>
              </TableRow>
              <TableRow>
              <TableCell style={{ width: 100 }} align="left">
                <p><LocationCityIcon/></p>
              </TableCell>
                <TableCell component="th" scope="row">
                  <p><b>Address</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  {this.state.currentService.location[0].address.join(', ')}
                </TableCell>
              </TableRow>
              <TableRow>
              <TableCell style={{ width: 100 }} align="left">
                <p><NotListedLocationIcon/></p>
              </TableCell>
                <TableCell component="th" scope="row">
                  <p><b>Location Type</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  {this.state.currentService.location[0].type[0]}
                </TableCell>
              </TableRow>
              <TableRow>
              <TableCell style={{ width: 100 }} align="left">
                <p><BusinessIcon/></p>
              </TableCell>
                <TableCell component="th" scope="row">
                  <p><b>Physical Type</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  {this.state.currentService.location[0].physicalType}
                </TableCell>
              </TableRow>
              <TableRow>
              <TableCell style={{ width: 100 }} align="left">
                <p><TravelExploreIcon/></p>
              </TableCell>
                <TableCell component="th" scope="row">
                  <p><b>Geo Position</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  <div><b>Latitude: </b>{this.state.currentService.location[0].position.latitude}</div>
                  <div><b>Longitude: </b>{this.state.currentService.location[0].position.longitude}</div>
                </TableCell>
              </TableRow>
              <TableRow>
              <TableCell style={{ width: 100 }} align="left">
                <p><AccessTimeIcon/></p>
              </TableCell>
                <TableCell component="th" scope="row">
                  <p><b>Location Operating Hours</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  <div>Days of Week: {this.state.currentService.location[0].hoursOfOperation[0].daysOfWeek}</div>
                  <div>Operating Times: {this.state.currentService.location[0].hoursOfOperation[0].allDay? <span className="tag is-primary">24hr</span> : 'TBC'}</div>
                </TableCell>
              </TableRow>
              <TableRow>
              <TableCell style={{ width: 100 }} align="left">
                <p><LocalPhoneIcon/></p>
              </TableCell>
                <TableCell component="th" scope="row">
                  <p><b>Telephone</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  {this.state.currentService.location[0].telecom}
                </TableCell>
              </TableRow>
          </TableBody>
        </Table>
      </TableContainer>
            </Typography>
          </AccordionDetails>
          </Accordion>
          <Accordion>
          <AccordionSummary
            expandIcon={<ExpandMoreIcon />}
            aria-controls="panel1a-content"
            id="panel1a-header"
          >
            <Typography><b>Provider Organisation</b></Typography>
          </AccordionSummary>
          <AccordionDetails>
            <Typography>
            <TableContainer component={Paper}>
        <Table sx={{ minWidth: 500 }} aria-label="custom pagination table">
          <TableBody>
              <TableRow>
                <TableCell style={{ width: 100 }} align="left">
                  <p><DriveFileRenameOutlineIcon/></p>
                </TableCell>
                <TableCell component="th" scope="row">
                  <p><b>Organisation Name</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  {this.state.currentService.providedBy.name}
                </TableCell>
              </TableRow>
              <TableRow>
              <TableCell style={{ width: 100 }} align="left">
                  <p><CategoryIcon/></p>
                </TableCell>
              <TableCell component="th" scope="row">
                  <p><b>Organisation Type</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  {this.state.currentService.providedBy.type}
                </TableCell>
              </TableRow>
              <TableRow>
                <TableCell style={{ width: 100 }} align="left">
                  <p><AccountTreeIcon/></p>
                </TableCell>
                <TableCell component="th" scope="row">
                  <p><b>ODS Code</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  {this.state.currentService.providedBy.identifier}
                </TableCell>
              </TableRow>
              <TableRow>
              <TableCell style={{ width: 100 }} align="left">
                  <p><RoomIcon/></p>
                </TableCell>
                <TableCell component="th" scope="row">
                  <p><b>Head Office Address</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  {this.state.currentService.providedBy.address.join(', ')}
                </TableCell>
              </TableRow>
              <TableRow>
              <TableCell style={{ width: 100 }} align="left">
                  <p><LocalPhoneIcon/></p>
                </TableCell>
                <TableCell component="th" scope="row">
                  <p><b>Telephone</b></p>
                </TableCell>
                <TableCell style={{ width: 360 }} align="right">
                  {this.state.currentService.providedBy.telecom[0]}
                </TableCell>
              </TableRow>
          </TableBody>
        </Table>
      </TableContainer>
            </Typography>
          </AccordionDetails>
          </Accordion>
          <Accordion>
          <AccordionSummary
            expandIcon={<ExpandMoreIcon />}
            aria-controls="panel1a-content"
            id="panel1a-header"
          >
            <Typography><b>Coverage Area</b></Typography>
          </AccordionSummary>
          <AccordionDetails>
            <Typography>
          <div style={{ height: '50vh', width: '100%' }}>
            <GoogleMapReact
              defaultCenter={serviceLocation.center}
              defaultZoom={10}
              yesIWantToUseGoogleMapApiInternals 
              onGoogleApiLoaded={({ map, maps }) => handleCoverageMapLoaded(map, maps)}
            >
            <LocationPin
                lat={this.state.currentService.location[0].position.latitude}
                lng={this.state.currentService.location[0].position.longitude}
              />
            </GoogleMapReact>
          </div>
            </Typography>
          </AccordionDetails>
          </Accordion>
            </Item>
          </Grid>
        </Grid>
        </div>
        </Container>
      </Fragment>

    )
  }
}

export default ServiceManagement



