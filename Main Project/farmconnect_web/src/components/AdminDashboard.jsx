import React, { useState, useEffect } from 'react';
import { collection, getDocs } from 'firebase/firestore';
import { Link } from 'react-router-dom';  
import firestore from '../firebase';
import Sidebar from './SideBar';


function AdminDashboard() {

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (!token) {
      window.location.href = '/'; 
    }
  }, []);

  const handleLogout = () => {
    localStorage.removeItem('token');
    window.location.href = '/';
  };

  return (
    <div><div className="container-scroller">
      <Sidebar/>
    {/* partial */}
    <div className="container-fluid page-body-wrapper mb-0">
      {/* partial:partials/_navbar.html */}
      <nav className="navbar p-0 fixed-top d-flex flex-row">
        <div className="navbar-menu-wrapper flex-grow d-flex align-items-stretch">
          <div className="w-100 d-flex justify-content-center align-items-center">
            <h3 className="text-center mb-0" style={{ fontFamily: 'Arial, sans-serif', color: '#fff', fontSize: '36px', fontWeight: 'bold'}}>
              FarmConnect Admin Dashboard
            </h3>
          </div>
          <div className="text-center">
            <button className="btn btn-danger" onClick={handleLogout}>Logout</button>
          </div>
        </div>
      </nav>

      {/* partial */}
      <div className="main-panel">
        <div className="content-wrapper">
        <div className="row" style={{ marginLeft: "180px" }}>
            <div className="col-sm-4 grid-margin">
            <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div className="row">
                    <div className="col-8 col-sm-12 col-xl-8 my-auto">
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-0">Farmers</h2>
                      </div>
                    </div>
                    <div className="col-4 col-sm-12 col-xl-4 text-center text-xl-right">
                      <i className="icon-lg mdi mdi-monitor text-success ml-auto" />
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            <div className="col-sm-4 grid-margin">
            <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div className="row">
                    <div className="col-8 col-sm-12 col-xl-8 my-auto">
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-0">Buyers</h2>
                      </div>
                    </div>
                    <div className="col-4 col-sm-12 col-xl-4 text-center text-xl-right">
                      <i className="icon-lg mdi mdi-monitor text-success ml-auto" />
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            <div className="col-sm-4 grid-margin">
            <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div className="row">
                    <div className="col-8 col-sm-12 col-xl-8 my-auto">
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-0">Farmer Pending</h2>
                      </div>
                    </div>
                    <div className="col-4 col-sm-12 col-xl-4 text-center text-xl-right">
                      <i className="icon-lg mdi mdi-monitor text-success ml-auto" />
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            <div className="col-sm-4 grid-margin">
            <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div className="row">
                    <div className="col-8 col-sm-12 col-xl-8 my-auto">
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-0">Products Pending</h2>
                      </div>
                    </div>
                    <div className="col-4 col-sm-12 col-xl-4 text-center text-xl-right">
                      <i className="icon-lg mdi mdi-monitor text-success ml-auto" />
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            <div className="col-sm-4 grid-margin">
            <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div className="row">
                    <div className="col-8 col-sm-12 col-xl-8 my-auto">
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-0">Farmers Rejected</h2>
                      </div>
                    </div>
                    <div className="col-4 col-sm-12 col-xl-4 text-center text-xl-right">
                      <i className="icon-lg mdi mdi-monitor text-success ml-auto" />
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            <div className="col-sm-4 grid-margin">
            <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div className="row">
                    <div className="col-8 col-sm-12 col-xl-8 my-auto">
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-0">Products Rejected</h2>
                      </div>
                    </div>
                    <div className="col-4 col-sm-12 col-xl-4 text-center text-xl-right">
                      <i className="icon-lg mdi mdi-monitor text-success ml-auto" />
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            <div className="col-sm-4 grid-margin">
            <Link to="/category-products" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div className="row">
                    <div className="col-8 col-sm-12 col-xl-8 my-auto">
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-0">Products Approved</h2>
                      </div>
                    </div>
                    <div className="col-4 col-sm-12 col-xl-4 text-center text-xl-right">
                      <i className="icon-lg mdi mdi-monitor text-success ml-auto" />
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            <div className="col-sm-4 grid-margin">
            <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div className="row">
                    <div className="col-8 col-sm-12 col-xl-8 my-auto">
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-0">Stock</h2>
                      </div>
                    </div>
                    <div className="col-4 col-sm-12 col-xl-4 text-center text-xl-right">
                      <i className="icon-lg mdi mdi-monitor text-success ml-auto" />
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            <div className="col-sm-4 grid-margin">
            <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div className="row">
                    <div className="col-8 col-sm-12 col-xl-8 my-auto">
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-0">Payments</h2>
                      </div>
                    </div>
                    <div className="col-4 col-sm-12 col-xl-4 text-center text-xl-right">
                      <i className="icon-lg mdi mdi-monitor text-success ml-auto" />
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            <div className="col-sm-4 grid-margin">
            <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div className="row">
                    <div className="col-8 col-sm-12 col-xl-8 my-auto">
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-0">Orders</h2>
                      </div>
                    </div>
                    <div className="col-4 col-sm-12 col-xl-4 text-center text-xl-right">
                      <i className="icon-lg mdi mdi-monitor text-success ml-auto" />
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

            <div className="col-sm-4 grid-margin">
            <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
              <div className="card">
                <div className="card-body">
                  <div className="row">
                    <div className="col-8 col-sm-12 col-xl-8 my-auto">
                      <div className="d-flex d-sm-block d-md-flex align-items-center">
                        <h2 className="mb-0">Category & Products</h2>
                      </div>
                    </div>
                    <div className="col-4 col-sm-12 col-xl-4 text-center text-xl-right">
                      <i className="icon-lg mdi mdi-monitor text-success ml-auto" />
                    </div>
                  </div>
                </div>
              </div>
              </Link>
            </div>

          </div>
        </div>
      </div>
    </div>
  </div>
</div>
  )
}

export default AdminDashboard