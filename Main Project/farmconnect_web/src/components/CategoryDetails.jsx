import React, { useState, useEffect } from 'react';
import { collection, query, getDocs } from 'firebase/firestore';
import firestore from '../firebase';

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

  return (
    <div>
      <h1>Category Details</h1>
      <table>
        <thead>
          <tr>
            <th>Category Name</th>
            <th>Product Names</th>
          </tr>
        </thead>
        <tbody>
          {categoryDetails.map(category => (
            <tr key={category.id}>
              <td>{category.categoryName}</td>
              <td>
                <ul>
                  {category.productNames.map((productName, index) => (
                    <li key={index}>{productName}</li>
                  ))}
                </ul>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default CategoryDetails;
