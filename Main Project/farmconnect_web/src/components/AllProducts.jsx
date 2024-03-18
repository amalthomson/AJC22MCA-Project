import React, { useState, useEffect } from 'react';
import { collection, getDocs } from 'firebase/firestore';
import firestore from '../firebase';
import Sidebar from './SideBar';
import './AllProducts.css';

const AllProducts = () => {
  const [categoryProducts, setCategoryProducts] = useState({});
  const [expandedCategory, setExpandedCategory] = useState(null);

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

    return () => {
    };
  }, []);

  const handleCategoryExpand = (category) => {
    setExpandedCategory(expandedCategory === category ? null : category);
  };

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (!token) {
      window.location.href = '/'; 
    }
  }, []);

  return (
    <div className="wrapper">
      <Sidebar />
      <div className="w-100 d-flex justify-content-center align-items-center">
            <h3 className="text-center mt-5 mb-0" style={{ fontFamily: 'Arial, sans-serif', color: '#fff', fontSize: '36px', fontWeight: 'bold'}}>
              All Products
            </h3>
          </div>
      <div className="content">
        <div className="category-container">
          {Object.keys(categoryProducts).map(category => (
            <div key={category} className="category-card">
              <div className="category-header" onClick={() => handleCategoryExpand(category)}>
                <h2 className="category-title">{category}</h2>
                <span className="expand-icon">{expandedCategory === category ? '-' : '+'}</span>
              </div>
              {expandedCategory === category && (
                <div className="product-container">
                  {categoryProducts[category].map(product => (
                    <div key={product.id} className="card">
                      <img src={product.productImage} alt={product.productName} className="card-image" />
                      <div className="card-content">
                        <h4 className="card-title">{product.productName}</h4>
                        <p className="card-price">Price: ₹ {product.productPrice}.00</p>
                        <p className="card-description">{product.productDescription}</p>
                        <p className="card-stock">Stock: {product.stock}/KG</p>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};

export default AllProducts;
