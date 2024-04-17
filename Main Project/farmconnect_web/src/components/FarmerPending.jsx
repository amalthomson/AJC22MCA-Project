import React, { useEffect, useState } from 'react';
import Modal from 'react-modal';
import { collection, query, where, getDocs, doc, updateDoc } from 'firebase/firestore';
import firestore from '../firebase';
import './FarmerDetails.css';
import Sidebar from './SideBar';

Modal.setAppElement('#root');

const FarmerPendingReactPage = () => {
  useEffect(() => {
    const token = localStorage.getItem('token');
    if (!token) {
      window.location.href = '/';
    }
  }, []);

  const [farmers, setFarmers] = useState([]);
  const [modalIsOpen, setModalIsOpen] = useState(false);
  const [aadhaarInfo, setAadhaarInfo] = useState('');
  const [selectedFarmerId, setSelectedFarmerId] = useState('');

  const fetchApprovedFarmers = async () => {
    try {
      const farmersRef = collection(firestore, 'users');
      const approvedFarmersQuery = query(
        farmersRef,
        where('role', '==', 'Farmer'),
        where('isAdminApproved', '==', 'pending')
      );

      const approvedFarmersSnapshot = await getDocs(approvedFarmersQuery);
      const approvedFarmersData = approvedFarmersSnapshot.docs.map(doc => ({
        id: doc.id,
        data: doc.data(),
      }));

      setFarmers(approvedFarmersData);
    } catch (error) {
      console.error('Error fetching approved farmers:', error);
    }
  };

  useEffect(() => {
    fetchApprovedFarmers();
  }, []);

  const handleViewId = (aadhaar, farmerId) => {
    setAadhaarInfo(aadhaar);
    setSelectedFarmerId(farmerId);
    setModalIsOpen(true);
  };

  const closeModal = () => {
    setModalIsOpen(false);
    setSelectedFarmerId('');
  };

  const handleApprove = async (farmerId) => {
    try {
      await updateDoc(doc(firestore, 'users', farmerId), {
        isAdminApproved: 'approved'
      });
      // After updating, fetch the updated list of farmers
      fetchApprovedFarmers();
    } catch (error) {
      console.error('Error approving farmer:', error);
    }
  };

  const handleReject = async (farmerId) => {
    try {
      await updateDoc(doc(firestore, 'users', farmerId), {
        isAdminApproved: 'rejected'
      });
      // After updating, fetch the updated list of farmers
      fetchApprovedFarmers();
    } catch (error) {
      console.error('Error rejecting farmer:', error);
    }
  };

  return (
    <div className="wrapper">
      <Sidebar />
      <div className="content">
        <div className="w-100 d-flex justify-content-center align-items-center">
          <h3 className="text-center mb-0" style={{ fontFamily: 'Arial, sans-serif', color: '#fff', fontSize: '36px', fontWeight: 'bold' }}>
            Farmers - Pending
          </h3>
        </div>
        <div className="container">
          {farmers.length === 0 ? (
            <p>No approved farmers found.</p>
          ) : (
            farmers.map(farmer => (
              <div key={farmer.id} className="farmer-card">
                <img
                  src={farmer.data.profileImageUrl || '/path/to/default/profile/image.jpg'}
                  alt="Profile Image"
                />
                <div className="farmer-details">
                  <center><h2>{farmer.data.name || 'N/A'}</h2></center>
                  <p>Email: {farmer.data.email || 'N/A'}</p>
                  <p>Phone: {farmer.data.phone || 'N/A'}</p>
                  <p>Gender: {farmer.data.gender || 'N/A'}</p>
                  <p>
                    Address: {`${farmer.data.street || 'N/A'}, ${farmer.data.town || 'N/A'}, ${farmer.data.district || 'N/A'}, ${farmer.data.state || 'N/A'}, ${farmer.data.pincode || 'N/A'}`}
                  </p>
                  <p>Farm Name: {farmer.data.farmName || 'N/A'}</p>
                  <p>Aadhaar: {farmer.data.aadhaar || 'N/A'}</p>
                </div>
                <div className="button-group">
                  <button
                    className="approve-button"
                    onClick={() => handleApprove(farmer.id)}
                  >
                    Approve
                  </button>
                  <button
                    className="reject-button"
                    onClick={() => handleReject(farmer.id)}
                  >
                    Reject
                  </button>
                </div>
              </div>
            ))
          )}
        </div>
      </div>

      <Modal
        isOpen={modalIsOpen}
        onRequestClose={closeModal}
        contentLabel="Aadhaar Information"
      >
        <h2>Aadhaar Information</h2>
        <p>{aadhaarInfo}</p>
        {selectedFarmerId && (
          <img
            src={farmers.find(farmer => farmer.id === selectedFarmerId)?.data.idCardImageUrl || '/path/to/default/id/card/image.jpg'}
            alt="ID Card Image"
            style={{ maxWidth: '100%' }}
          />
        )}
        <button onClick={closeModal}>Close</button>
      </Modal>
    </div>
  );
};

export default FarmerPendingReactPage;
