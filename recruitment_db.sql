-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 19, 2026 at 06:09 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `recruitment_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `applications`
--

CREATE TABLE `applications` (
  `id` bigint(20) NOT NULL,
  `job_id` bigint(20) NOT NULL,
  `candidate_id` bigint(20) NOT NULL,
  `resume_path` varchar(512) NOT NULL,
  `status` enum('SUBMITTED','SHORTLISTED','REJECTED','INTERVIEW_SCHEDULED') DEFAULT 'SUBMITTED',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `applications`
--

INSERT INTO `applications` (`id`, `job_id`, `candidate_id`, `resume_path`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 1, '/var/storage/resumes/candidate_1_cv.pdf', 'SUBMITTED', '2026-06-19 13:00:40', '2026-06-19 13:00:40'),
(2, 1, 2, '/var/storage/resumes/candidate_2_cv.pdf', 'SHORTLISTED', '2026-06-19 15:50:49', '2026-06-19 15:53:55');

-- --------------------------------------------------------

--
-- Table structure for table `event_log`
--

CREATE TABLE `event_log` (
  `event_id` varchar(36) NOT NULL,
  `event_type` varchar(100) NOT NULL,
  `payload` longtext NOT NULL,
  `retry_count` int(11) DEFAULT 0,
  `state` enum('PENDING','PROCESSED','FAILED') DEFAULT 'PENDING',
  `exception_context` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `event_log`
--

INSERT INTO `event_log` (`event_id`, `event_type`, `payload`, `retry_count`, `state`, `exception_context`, `created_at`, `updated_at`) VALUES
('5699967f-e387-4eb9-ad22-70516c21b669', 'JOB_CREATED', '{\"title\":\"Software Engineering\",\"recruiterId\":3,\"location\":\"Main Branch, Cyberjaya\"}', 0, 'PROCESSED', NULL, '2026-06-19 13:00:11', '2026-06-19 13:00:11'),
('87e5a9f4-191e-4e3a-9472-bdaf242179df', 'APPLICATION_SUBMITTED', '{\"jobId\":1,\"candidateId\":1,\"resumePath\":\"/var/storage/resumes/candidate_1_cv.pdf\"}', 0, 'PROCESSED', NULL, '2026-06-19 13:00:40', '2026-06-19 13:00:41'),
('f3f1c148-b87e-4a23-833d-ba1de3ebdefd', 'APPLICATION_SUBMITTED', '{\"jobId\":1,\"candidateId\":2,\"resumePath\":\"/var/storage/resumes/candidate_2_cv.pdf\"}', 0, 'PROCESSED', NULL, '2026-06-19 15:50:49', '2026-06-19 15:50:50');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) NOT NULL,
  `recruiter_id` bigint(20) NOT NULL,
  `title` varchar(150) NOT NULL,
  `description` text NOT NULL,
  `required_skills` text NOT NULL,
  `salary_range` varchar(50) DEFAULT NULL,
  `location` varchar(100) DEFAULT NULL,
  `status` enum('PUBLISHED','CLOSED') DEFAULT 'PUBLISHED',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `jobs`
--

INSERT INTO `jobs` (`id`, `recruiter_id`, `title`, `description`, `required_skills`, `salary_range`, `location`, `status`, `created_at`, `updated_at`) VALUES
(1, 3, 'Software Engineering', 'Internship for Software Developer', 'Java, Postman, MySQL and related', 'RM 1500.00 - RM 1600.00', 'Main Branch, Cyberjaya', 'PUBLISHED', '2026-06-19 13:00:11', '2026-06-19 13:00:11');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('CANDIDATE','RECRUITER') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password_hash`, `role`, `created_at`) VALUES
(1, 'aiman Maslan', 'aiman@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'CANDIDATE', '2026-06-19 12:56:32'),
(2, 'radilan', 'lan@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'CANDIDATE', '2026-06-19 12:57:27'),
(3, 'Petronas Sdn Bhd', 'petro@gmail.com', 'a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3', 'RECRUITER', '2026-06-19 12:58:29');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `applications`
--
ALTER TABLE `applications`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_job_candidate` (`job_id`,`candidate_id`),
  ADD KEY `candidate_id` (`candidate_id`);

--
-- Indexes for table `event_log`
--
ALTER TABLE `event_log`
  ADD PRIMARY KEY (`event_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `recruiter_id` (`recruiter_id`);
ALTER TABLE `jobs` ADD FULLTEXT KEY `fx_job_search` (`title`,`description`,`required_skills`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `applications`
--
ALTER TABLE `applications`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `applications`
--
ALTER TABLE `applications`
  ADD CONSTRAINT `applications_ibfk_1` FOREIGN KEY (`job_id`) REFERENCES `jobs` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `applications_ibfk_2` FOREIGN KEY (`candidate_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `jobs`
--
ALTER TABLE `jobs`
  ADD CONSTRAINT `jobs_ibfk_1` FOREIGN KEY (`recruiter_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
