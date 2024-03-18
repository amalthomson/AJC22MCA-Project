import React, { useState, useEffect } from 'react';
import { collection, getDocs } from 'firebase/firestore';
import firestore from '../firebase';
import './CategoryDetails.css';
import Sidebar from './SideBar';

const CategoryDetails = () => {
  const [categoryDetails, setCategoryDetails] = useState([]);

  useEffect(() => {
    const fetchCategoryDetails = async () => {
      try {
        const q = collection(firestore, 'categories');
        const querySnapshot = await getDocs(q);

        const data = querySnapshot.docs.map(doc => ({
          id: doc.id,
          categoryName: doc.data().categoryName,
          productNames: doc.data().productNames
        }));
        
        setCategoryDetails(data);
      } catch (error) {
        console.error('Error fetching category details:', error);
      }
    };

    fetchCategoryDetails();

    // Cleanup function
    return () => {
      // Clean up any ongoing operations, such as closing listeners, if necessary
    };
  }, []); // Empty dependency array ensures this effect runs only once on component mount

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (!token) {
      window.location.href = '/'; 
    }
  }, []);

  return (
    <div className="wrapper">
      <Sidebar/>
      <div className="w-100 d-flex justify-content-center align-items-center">
            <h3 className="text-center mt-5 mb-0" style={{ fontFamily: 'Arial, sans-serif', color: '#fff', fontSize: '36px', fontWeight: 'bold'}}>
              Products & Category
            </h3>
          </div>
      <div className="content">
        <div className="container">
          <div className="category-cards">
            {categoryDetails.map(category => (
              <div key={category.id} className="card">
                <div className="card-content">
                  <h3 className="card-title">{category.categoryName}</h3>
                  <ul className="product-list">
                    {category.productNames.map((productName, index) => (
                      <li key={index}>➥ {productName}</li>
                    ))}
                  </ul>
                </div>
              </div>
            ))}
          </div>
        </div>
      </div>
    </div>
  );
};

export default CategoryDetails;
