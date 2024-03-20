import React, { useEffect } from 'react';
// import { collection, getDocs } from 'firebase/firestore';
import { Link } from 'react-router-dom'; 
// import firestore from '../firebase';
import './Sidebar.css';

export default function Sidebar() {

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (!token) {
      window.location.href = '/'; 
    }
  }, []);

  return (
    <div style={{overflowY: 'auto'}}>
      <nav className="sidebar sidebar-offcanvas" id="sidebar" style={{ paddingTop:"1px",backgroundColor: 'black' }}>
        {/* <div className="sidebar-brand-wrapper d-none d-lg-flex align-items-center justify-content-center fixed-top" style={{ backgroundColor: '#000' }}>
          <h3 className="mb-0 font-weight-bold">FARMCONNECT</h3>
        </div> */}
        <ul className="nav">
          <li className="nav-item profile">
            <div className="profile-desc">
              <div className="profile-pic">
                <div className="count-indicator">
                  <img className="img-xs rounded-circle " src="assets/appLogoDark.png" alt=""/>
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
            <span className="menu-title" style={{ color: 'white' }}>Dashboard</span>
          </a>
        </li>
      </Link>

      <li className="nav-item menu-items">
            <Link to="/farmers" style={{ textDecoration: 'none' }}>
              <a className="nav-link" href="pages/forms/basic_elements.html">
                <span className="menu-icon">
                  <i className="mdi mdi-playlist-play" />
                </span>
                <span className="menu-title" style={{ color: 'white' }}>Farmers</span>
              </a>
            </Link>
            <ul className="submenu">
              <li className="nav-item">
                <Link to="/farmer-details" style={{ textDecoration: 'none' }}>
                  <a className="nav-link" href="#" style={{ color: 'white' }}>
                    Farmers Approved
                  </a>
                </Link>
              </li>
              <li className="nav-item">
                <Link to="/farmer-pending" style={{ textDecoration: 'none' }}>
                  <a className="nav-link" href="#" style={{ color: 'white' }}>
                    Farmers Pending
                  </a>
                </Link>
              </li>
              <li className="nav-item">
                <Link to="/farmer-rejected" style={{ textDecoration: 'none' }}>
                  <a className="nav-link" href="#" style={{ color: 'white' }}>
                    Farmers Rejected
                  </a>
                </Link>
              </li>
            </ul>
          </li>

          <Link to="/buyer-details" style={{ textDecoration: 'none' }}>
        <li className="nav-item menu-items">
          <a className="nav-link" href="pages/tables/basic-table.html">
            <span className="menu-icon">
              <i className="mdi mdi-table-large" />
            </span>
            <span className="menu-title" style={{ color: 'white' }}>Buyers</span>
          </a>
        </li>
      </Link>

          <li className="nav-item menu-items">
            <Link to="/products" style={{ textDecoration: 'none' }}>
              <a className="nav-link" href="pages/forms/basic_elements.html">
                <span className="menu-icon">
                  <i className="mdi mdi-playlist-play" />
                </span>
                <span className="menu-title" style={{ color: 'white' }}>Products</span>
              </a>
            </Link>
            <ul className="submenu">
              <li className="nav-item">
                <Link to="/all-products" style={{ textDecoration: 'none' }}>
                  <a className="nav-link" href="#" style={{ color: 'white' }}>
                    All Products
                  </a>
                </Link>
              </li>
              <li className="nav-item">
                <Link to="/products-approved" style={{ textDecoration: 'none' }}>
                  <a className="nav-link" href="#" style={{ color: 'white' }}>
                    Products Approved
                  </a>
                </Link>
              </li>
              <li className="nav-item">
                <Link to="/products-pending" style={{ textDecoration: 'none' }}>
                  <a className="nav-link" href="#" style={{ color: 'white' }}>
                    Products Pending
                  </a>
                </Link>
              </li>
              <li className="nav-item">
                <Link to="/products-rejected" style={{ textDecoration: 'none' }}>
                  <a className="nav-link" href="#" style={{ color: 'white' }}>
                    Products Rejected
                  </a>
                </Link>
              </li>
              <li className="nav-item">
                <Link to="/stock-details" style={{ textDecoration: 'none' }}>
                  <a className="nav-link" href="#" style={{ color: 'white' }}>
                    Stock
                  </a>
                </Link>
              </li>
              <li className="nav-item">
                <Link to="/review-details" style={{ textDecoration: 'none' }}>
                  <a className="nav-link" href="#" style={{ color: 'white' }}>
                    Product Reviews
                  </a>
                </Link>
              </li>
              <li className="nav-item">
                <Link to="/category-details" style={{ textDecoration: 'none' }}>
                  <a className="nav-link" href="#" style={{ color: 'white' }}>
                    Products & Category
                  </a>
                </Link>
              </li>
            </ul>
          </li>

      <Link to="/payment-details" style={{ textDecoration: 'none' }}>
        <li className="nav-item menu-items">
          <a className="nav-link" href="pages/icons/mdi.html">
            <span className="menu-icon">
              <i className="mdi mdi-contacts" />
            </span>
            <span className="menu-title" style={{ color: 'white' }}>Payments</span>
          </a>
        </li>
      </Link>

      <Link to="/order-details" style={{ textDecoration: 'none' }}>
        <li className="nav-item menu-items">
          <a className="nav-link" href="pages/icons/mdi.html">
            <span className="menu-icon">
              <i className="mdi mdi-contacts" />
            </span>
            <span className="menu-title" style={{ color: 'white' }}>Orders</span>
          </a>
        </li>
      </Link>

      </ul>
    </nav>
    </div>
  )
}
