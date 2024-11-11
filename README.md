# Odinbook

Odinbook is a social media platform built with Ruby on Rails that allows users to share posts, comment, and interact through likes. It is designed to mimic basic functionalities of popular social networks, providing an environment to practice and showcase Rails development skills.

## Features

- **User Authentication**: Sign up and login functionalities using Devise.
- **Post Creation**: Users can create, edit, and delete posts.
- **Comments**: Ability to comment on posts.
- **Likes**: Users can like or unlike posts and comments.
- **Responsive Design**: Built with Bootstrap for mobile and desktop responsiveness.

## Installation

To get a local copy running, follow these steps:

### Prerequisites

- Ruby (version specified in `.ruby-version`)
- Ruby on Rails (version 7.1 or later)
- PostgreSQL database
- Node.js and Yarn

### Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/odinbook.git
   cd odinbook
   ```

2. **Install dependencies:**
   ```bash
   bundle install
   yarn install
   ```

3. **Set up the database:**
   ```bash
rails db:create
rails db:migrate
   ```

4. **Start the Rails server:**
   ```bash
rails server
   ```

5. **Access the application:**
   Open your web browser and navigate to `http://localhost:3000`

## Usage

- **Sign Up:** Create a new account through the registration page
- **Create Posts:** Share your thoughts by creating new posts
- **Interact:** Comment on and like posts by other users
- **Profile:** View and edit your profile information