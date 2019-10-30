import React, { Component } from 'react';
import logo from '../logo.png';
import './App.css';
import Web3 from 'web3';
import addluggage2 from '../abis/addLuggage2.json'
import Main from './Main';
import NavBar from './NavBar';

class App extends Component {
  async componentWillMount() {
    await this.loadWeb3()
    await this.loadBlockChainData()  
    this.getLuggages()
  }
  async loadWeb3() {
    if(window.ethereum) {
      window.web3= new Web3(window.ethereum)
      await window.ethereum.enable()
    }
    else if(window.web3) {
      window.web3=new Web3(window.web3.currentProvider)
    }
    else {
      window.alert('Non-Ethereum browser detected. You should consider trying Metamask!')
    } 
  }
  constructor(props) {
    super(props)
    this.state={account: '',
                loading:true,
                luggages:[],
                add_msg: "",
                send_msg: "",
                receive_msg: "",
              }
    this.addLuggage = this.addLuggage.bind(this)
    this.sendLuggage = this.sendLuggage.bind(this)
    this.receiveLuggage = this.receiveLuggage.bind(this)
    this.locatemyLuggage = this.locatemyLuggage.bind(this)
  }

  async loadBlockChainData()
  {
    const web3=window.web3
    //load account 
    const accounts = await web3.eth.getAccounts()
    this.setState({account: accounts[0]})  
    console.log(this.state.account)
    const networkId=await web3.eth.net.getId()
    //  console.log(networkId)
    const networkData=addluggage2.networks[networkId]
    if(networkData)
    {
      const luggage = new web3.eth.Contract(addluggage2.abi,networkData.address)
      console.log("networkid", networkId)
      console.log("networkdata", networkData)
      console.log("abi", addluggage2.abi)
      console.log("luggage", luggage)
      // luggage.options.address = networkData.address
      this.setState({ luggage })
      console.log(this.state.luggage.methods.createAsset)
      // this.getLuggages()
      this.setState({ loading: false })
    }
    else
    {
      window.alert('Market place is not deployed to a proper network')
    }
  }

  addLuggage(uuid, weight, airport_initial) {
    this.setState({ loading: true })
    this.state.luggage.methods.createAsset(uuid, weight, airport_initial).send({ from: this.state.account })
    .once('receipt', (receipt) => {
      this.setState({ loading: false })
    })
    this.getLuggages()
    console.log("Added luggage with UUID: ", uuid, "Weight: ", weight, "Airport: ", airport_initial)
    this.setState({ add_msg: "Added luggage with UUID: " + uuid + ", Weight: " + weight + ", Airport: " + airport_initial, send_msg: "", receive_msg: "" })
    // this.state.luggage.createAsset(uuid, weight, airport_initial, function(error, result) { console.log("Result: ", result, " Error:", error); } )
  }

  sendLuggage(airport_from, airport_to, uuid) {
    this.setState({ loading: true })
    this.state.luggage.methods.sendAsset(airport_from, airport_to, uuid).send({ from: this.state.account })
    .once('receipt', (receipt) => {
      this.setState({ loading: false })
    })
    this.getLuggages()
    console.log("Sent luggage with UUID: ", uuid, " From ", airport_from, " To ", airport_to)
    this.setState({ add_msg: "", send_msg: "Sent luggage with UUID: " + uuid + " From " + airport_from + " To " + airport_to, receive_msg: "" })
  }

  receiveLuggage(airport_from, airport_to, uuid) {
    this.setState({ loading: true })
    this.state.luggage.methods.receiveAsset(airport_from, airport_to, uuid).send({ from: this.state.account })
    .once('receipt', (receipt) => {
      this.setState({ loading: false })
    })
    this.getLuggages()
    console.log("Received luggage with UUID: ", uuid, " From ", airport_from, " To ", airport_to)
    this.setState({ add_msg: "", send_msg: "" , receive_msg: "Received luggage with UUID: " + uuid + " From " + airport_from + " To " + airport_to })
  }

  locatemyLuggage(uuid) {
    this.setState({ loading: true })
    this.state.luggage.methods.locateMyLuggage(uuid).call().then((results) => {
      console.log(results)
      if(results.toString() != "Luggage received at \n") {
        window.alert(results.toString())
      }
      else {
        window.alert("Luggage with UUID " + uuid + " does not exist");
      }
      this.setState({ loading: false })
    })
  }

  trackLuggage(uuid) {
    this.setState({ loading: true })
    this.state.luggage.methods.trackLuggage(uuid).call().then((results) => {
      console.log(results[0])
      if(results[0].toString() != "Luggage received at \n") {
        window.alert(results[0].toString())
      }
      else {
        window.alert("Luggage with UUID " + uuid + " does not exist");
      }
      this.setState({ loading: false })
    })
  }

  getLuggages() {
    fetch('http://localhost:5000/getAllUUIDs/')
            .then((response) => { return response.text() })
            .then((text) => {
                console.log(text)
                let uuids = text.split(",")
                let luggages = []
                for(let i=0; i<uuids.length; ++i) {
                  let results = this.state.luggage.methods.getAssetByUUID(uuids[i]).call().then(function(results) {
                    luggages.push({uuid: uuids[i], weight: results[0].toString(), "airport_initial":results[1]})
                    
                  })
                }
                console.log("Luggages", luggages)
                this.setState({ luggages: luggages })
                console.log(this.state.luggages)
              }
          )
  }

  render() {
    return (
      <div>
        <NavBar account={this.state.account} />
        <div className="container-fluid mt-5" style={{paddingLeft: '25px'}}>
          <div className="row">
            <main role="main" className="col-lg-12 d-flex"></main>
              {
                this.state.loading
                ? <div id="loader" className="text-center"><p className="text-center">Loading...</p></div>
                : <Main addLuggage={this.addLuggage} sendLuggage={this.sendLuggage} receiveLuggage={this.receiveLuggage} add_msg={this.state.add_msg} send_msg={this.state.send_msg} receive_msg={this.state.receive_msg} luggages={this.state.luggages} />
              }
              <form style={{paddingLeft: '30px'}}>
                    <h1>Track and Locate Luggage</h1>
                    <input
                    id="uuid_locate"
                    type="text"
                    ref={(input) => { this.uuid_locate = input }}
                    className="form-control"
                    placeholder="Enter UUID to track luggage"
                    required /><br />
                    <button type="button" className="btn btn-primary" onClick={() => this.locatemyLuggage(this.uuid_locate.value)}>Locate</button>&nbsp;
                    <button type="button" className="btn btn-primary" onClick={() => this.trackLuggage(this.uuid_locate.value)}>Track</button>
              </form>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
