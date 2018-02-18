CREATE database testtube;
GRANT ALL PRIVILEGES ON *.* TO 'service_user'@'%' IDENTIFIED BY 'ThisIsATest1';
USE testtube;

CREATE TABLE video (
	title VARCHAR(64),
    description TEXT,
    video_path VARCHAR(400),
    public_url VARCHAR(400),
    video_uuid VARCHAR(100),
    -- video_id int NOT NULL AUTO_INCREMENT,
    PRIMARY KEY(video_uuid)
);
