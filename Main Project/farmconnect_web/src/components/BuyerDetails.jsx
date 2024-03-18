import React, { useEffect, useState } from 'react';
import { collection, query, where, getDocs } from 'firebase/firestore';
import firestore from '../firebase';
import './BuyerDetails.css';
import Sidebar from './SideBar';

const BuyerDetailsReactPage = () => {
  useEffect(() => {
    const token = localStorage.getItem('token');
    if (!token) {
      window.location.href = '/'; 
    }
  }, []);

  const [buyers, setBuyers] = useState([]);

  useEffect(() => {
    const fetchApprovedBuyers = async () => {
      try {
        const buyersRef = collection(firestore, 'users');
        const approvedBuyersQuery = query(
          buyersRef,
          where('role', '==', 'Buyer')
        );

        const approvedBuyersSnapshot = await getDocs(approvedBuyersQuery);

        const approvedBuyersData = approvedBuyersSnapshot.docs.map(doc => ({
          id: doc.id,
          data: doc.data(),
        }));

        setBuyers(approvedBuyersData);
      } catch (error) {
        console.error('Error fetching approved buyers:', error);
      }
    };

    fetchApprovedBuyers();
  }, []);

  return (
    <div className="wrapper">
      <Sidebar/>
      <div className="content">
      <div className="w-100 d-flex justify-content-center align-items-center">
            <h3 className="text-center mb-0" style={{ fontFamily: 'Arial, sans-serif', color: '#fff', fontSize: '36px', fontWeight: 'bold'}}>
              Buyers
            </h3>
          </div>
        <div className="container">
          {buyers.length === 0 ? (
            <p>No approved buyers found.</p>
          ) : (
            buyers.map(buyer => (
              <div key={buyer.id} className="buyer-card">
                <img
                  src={buyer.data.profileImageUrl || '/path/to/default/profile/image.jpg'}
                  alt="Profile Image"
                />
                <h2>{buyer.data.name || 'N/A'}</h2>
                <div className="buyer-details">
                  <p>Email: {buyer.data.email || 'N/A'}</p>
                  <p>Phone: {buyer.data.phone || 'N/A'}</p>
                  <p>Gender: {buyer.data.gender || 'N/A'}</p>
                  <p>
                    Address: {`${buyer.data.street || 'N/A'}, ${buyer.data.town || 'N/A'}, ${buyer.data.district || 'N/A'}, ${buyer.data.state || 'N/A'}, ${buyer.data.pincode || 'N/A'}`}
                  </p>
                </div>
              </div>
            ))
          )}
        </div>
      </div>
    </div>
  );
};

export default BuyerDetailsReactPage;
