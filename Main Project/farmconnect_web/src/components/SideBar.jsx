import React, { useState, useEffect } from 'react';
import { collection, getDocs } from 'firebase/firestore';
import { Link } from 'react-router-dom'; 
import firestore from '../firebase';

export default function Sidebar() {
  return (
    <div style={{ height: '100vh', overflowY: 'auto' }}>
      <nav className="sidebar sidebar-offcanvas" id="sidebar" style={{ backgroundColor: 'black' }}>
        <div className="sidebar-brand-wrapper d-none d-lg-flex align-items-center justify-content-center fixed-top">
          <h3 className="mb-0 font-weight-bold">FARMCONNECT</h3>
        </div>
        <ul className="nav">
          <li className="nav-item profile">
            <div className="profile-desc">
              <div className="profile-pic">
                <div className="count-indicator">
                  <img className="img-xs rounded-circle " src="assets/images/faces/face15.jpg" alt />
                  <span className="count bg-success" />
                </div>
                <div className="profile-name">
                  <h5 className="mb-0 font-weight-normal">ADMIN</h5>
                  <span>FarmConnect</span>
                </div>
              </div>
            </div>
          </li>

      <Link to="/admin-dashboard" style={{ textDecoration: 'none' }}>
        <li className="nav-item menu-items">
          <a className="nav-link" href="index.html">
            <span className="menu-icon">
              <i className="mdi mdi-speedometer" />
            </span>
            <span className="menu-title">Dashboard</span>
          </a>
        </li>
      </Link>

      <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
        <li className="nav-item menu-items">
          <a className="nav-link" href="pages/forms/basic_elements.html">
            <span className="menu-icon">
              <i className="mdi mdi-playlist-play" />
            </span>
            <span className="menu-title">Farmers</span>
          </a>
        </li>
      </Link>

      <Link to="/buyer-details" style={{ textDecoration: 'none' }}>
        <li className="nav-item menu-items">
          <a className="nav-link" href="pages/tables/basic-table.html">
            <span className="menu-icon">
              <i className="mdi mdi-table-large" />
            </span>
            <span className="menu-title">Buyers</span>
          </a>
        </li>
      </Link>

      <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
        <li className="nav-item menu-items">
          <a className="nav-link" href="pages/charts/chartjs.html">
            <span className="menu-icon">
              <i className="mdi mdi-chart-bar" />
            </span>
            <span className="menu-title">Farmer Pending</span>
          </a>
        </li>
      </Link>

      <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
        <li className="nav-item menu-items">
          <a className="nav-link" href="pages/icons/mdi.html">
            <span className="menu-icon">
              <i className="mdi mdi-contacts" />
            </span>
            <span className="menu-title">Products Pending</span>
          </a>
        </li>
      </Link>

      <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
        <li className="nav-item menu-items">
          <a className="nav-link" href="pages/icons/mdi.html">
            <span className="menu-icon">
              <i className="mdi mdi-contacts" />
            </span>
            <span className="menu-title">Farmers Rejected</span>
          </a>
        </li>
      </Link>

      <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
        <li className="nav-item menu-items">
          <a className="nav-link" href="pages/icons/mdi.html">
            <span className="menu-icon">
              <i className="mdi mdi-contacts" />
            </span>
            <span className="menu-title">Products Rejected</span>
          </a>
        </li>
      </Link>

      <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
        <li className="nav-item menu-items">
          <a className="nav-link" href="pages/icons/mdi.html">
            <span className="menu-icon">
              <i className="mdi mdi-contacts" />
            </span>
            <span className="menu-title">Products Approved</span>
          </a>
        </li>
      </Link>

      <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
        <li className="nav-item menu-items">
          <a className="nav-link" href="pages/icons/mdi.html">
            <span className="menu-icon">
              <i className="mdi mdi-contacts" />
            </span>
            <span className="menu-title">Stock</span>
          </a>
        </li>
      </Link>

      <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
        <li className="nav-item menu-items">
          <a className="nav-link" href="pages/icons/mdi.html">
            <span className="menu-icon">
              <i className="mdi mdi-contacts" />
            </span>
            <span className="menu-title">Payments</span>
          </a>
        </li>
      </Link>

      <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
        <li className="nav-item menu-items">
          <a className="nav-link" href="pages/icons/mdi.html">
            <span className="menu-icon">
              <i className="mdi mdi-contacts" />
            </span>
            <span className="menu-title">Orders</span>
          </a>
        </li>
      </Link>

      <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
        <li className="nav-item menu-items">
          <a className="nav-link" href="pages/icons/mdi.html">
            <span className="menu-icon">
              <i className="mdi mdi-contacts" />
            </span>
            <span className="menu-title">Cateory & Products</span>
          </a>
        </li>
      </Link>

      </ul>
    </nav>
    </div>
  )
}
