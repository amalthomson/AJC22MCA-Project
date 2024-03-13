import React, { useEffect, useState } from 'react';
import firebase from '../firebase'; 

export default function CategoryWiseProducts() {
  const [productsByCategory, setProductsByCategory] = useState([]);

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        const snapshot = await firebase.firestore().collection('products').where('isApproved', '==', 'Approved').get();
        const products = snapshot.docs.map(doc => doc.data());
        const productsByCategory = {};

        products.forEach(product => {
          const category = product.category;
          const productName = product.productName;

          if (!productsByCategory[category]) {
            productsByCategory[category] = {};
          }

          if (!productsByCategory[category][productName]) {
            productsByCategory[category][productName] = [];
          }

          productsByCategory[category][productName].push(product);
        });

        setProductsByCategory(productsByCategory);
      } catch (error) {
        console.error('Error fetching products:', error);
      }
    };

    fetchProducts();
  }, []);

  return (
    <div>
      <h1 style={{ color: 'white' }}>Product Categories</h1>
      {Object.keys(productsByCategory).map(category => (
        <div key={category}>
          <h2 style={{ color: 'blue' }}>Category: {category}</h2>
          {Object.keys(productsByCategory[category]).map(productName => (
            <div key={productName}>
              <h3 style={{ color: 'blue' }}>Product Name: {productName}</h3>
              {productsByCategory[category][productName].map(product => (
                <div key={product.productId}>
                  <img src={product.productImage} alt="Product" style={{ width: '100px' }} />
                  <p>Product Price: ₹{product.productPrice}.00</p>
                  <p>Product Description: {product.productDescription}</p>
                  <p>Stock: {product.stock} KG</p>
                </div>
              ))}
            </div>
          ))}
        </div>
      ))}
    </div>
  );
}
