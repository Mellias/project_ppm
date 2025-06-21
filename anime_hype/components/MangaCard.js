import React from 'react';
import { Link } from 'react-router-dom';

const MangaCard = ({ manga }) => {
    return (
        <div className="manga-card">
            <Link to={`/ongoingManga/${manga.mal_id}`}>View Details</Link>
        </div>
    );
};

export default MangaCard;
