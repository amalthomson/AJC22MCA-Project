import React, { useState, useEffect } from 'react';
import { collection, query, getDocs } from 'firebase/firestore';
import firestore from '../firebase';
import './AllProducts.css'; // Import the CSS file
import Sidebar from './SideBar';

const AllProducts = () => {
  const [categoryProducts, setCategoryProducts] = useState({});

  useEffect(() => {
    const fetchProductsByCategory = async () => {
      try {
        const q = collection(firestore, 'products');
        const querySnapshot = await getDocs(q);

        const categorizedProducts = {};

        querySnapshot.forEach(doc => {
          const product = doc.data();
          const category = product.category;
          if (!categorizedProducts[category]) {
            categorizedProducts[category] = [];
          }
          categorizedProducts[category].push({ id: doc.id, ...product });
        });

        setCategoryProducts(categorizedProducts);
      } catch (error) {
        console.error('Error fetching products by category:', error);
      }
    };

    fetchProductsByCategory();

    // Cleanup function
    return () => {
      // Clean up any ongoing operations, such as closing listeners, if necessary
    };
  }, []); // Empty dependency array ensures this effect runs only once on component mount

  return (
    <div className="wrapper">
      <nav className="navbar p-0 fixed-top d-flex flex-row">
        <div className="navbar-menu-wrapper flex-grow d-flex align-items-stretch">
          <div className="w-100 d-flex justify-content-center align-items-center">
            <h3 className="text-center mb-0" style={{ fontFamily: 'Arial, sans-serif', color: '#fff', fontSize: '36px', fontWeight: 'bold'}}>
              All Products
            </h3>
          </div>
        </div>
      </nav>
      <Sidebar className="sidebar"/> {/* Add className prop */}
      <div className="content"> {/* Add className prop */}
        <div className="all-products-container">
          {Object.keys(categoryProducts).map(category => (
            <div key={category} className="category-card">
              <h2>{category}</h2>
              <table className="product-table">
                <thead>
                  <tr>
                    <th>Product Name</th>
                    <th>Price</th>
                    <th>Description</th>
                    <th>Image</th>
                    <th>Stock</th>
                  </tr>
                </thead>
                <tbody>
                  {categoryProducts[category].map(product => (
                    <tr key={product.id} className="product-row">
                      <td>{product.productName}</td>
                      <td>{product.productPrice}.00</td>
                      <td>{product.productDescription}</td>
                      <td>
                        <img src={product.productImage} alt={product.productName} className="product-image" />
                      </td>
                      <td>{product.stock}/KG</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default AllProducts;
