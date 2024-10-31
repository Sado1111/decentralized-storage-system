# Decentralized Storage System

Welcome to the Decentralized Storage System! This smart contract provides a robust solution for storing, managing, and sharing files on the blockchain. It incorporates features such as file uploads, ownership transfers, access permissions, and detailed file descriptions, ensuring a user-friendly experience.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Contract Structure](#contract-structure)
- [Functions](#functions)
  - [Public Functions](#public-functions)
  - [Read-only Functions](#read-only-functions)
- [Error Handling](#error-handling)
- [Usage](#usage)
- [License](#license)

## Overview

The Decentralized Storage System allows users to securely upload and manage files in a decentralized manner. Users can store metadata about files, including file names, owners, sizes, upload times, descriptions, and tags.

## Features

- **File Upload**: Users can upload files with detailed metadata.
- **Ownership Management**: File owners can transfer ownership and modify file details.
- **Access Control**: Users can set permissions for other users to access files.
- **File Metadata**: Each file includes a description and tags for better organization.
- **Robust Error Handling**: Clear error messages for invalid operations.

## Contract Structure

The contract consists of the following main components:

- **Storage Variables and Maps**: Holds the count of files and maps for file details and access permissions.
- **Helper Functions**: Used for internal logic to check file existence and ownership.
- **Public Functions**: Expose functionality to interact with the contract.
- **Read-only Functions**: Provide access to contract state without modifying it.

## Functions

### Public Functions

1. **upload-new-file**
   - Uploads a new file with metadata.
   - **Parameters**:
     - `file-name`: The name of the file.
     - `file-size`: The size of the file in bytes.
     - `description`: A brief description of the file.
     - `tags`: A list of tags for categorizing the file.

2. **change-file-owner**
   - Transfers ownership of a file to a new user.
   - **Parameters**:
     - `identifier`: The unique identifier of the file.
     - `new-owner`: The principal of the new owner.

3. **modify-file**
   - Modifies the details of an existing file.
   - **Parameters**:
     - `identifier`: The unique identifier of the file.
     - `new-name`: The new name for the file.
     - `new-size`: The new size of the file.
     - `new-description`: The new description of the file.
     - `new-tags`: The new list of tags for the file.

4. **remove-file**
   - Deletes a file from the system.
   - **Parameters**:
     - `identifier`: The unique identifier of the file.

5. **set-access**
   - Sets access permissions for a specified user.
   - **Parameters**:
     - `identifier`: The unique identifier of the file.
     - `access`: Boolean indicating access permission.
     - `recipient`: The principal of the user to set permissions for.

6. **revoke-access**
   - Revokes access permissions for a specified user.
   - **Parameters**:
     - `identifier`: The unique identifier of the file.
     - `user`: The principal of the user whose access is being revoked.

### Read-only Functions

1. **retrieve-file-details**
   - Retrieves details of a specified file.
   - **Parameters**:
     - `identifier`: The unique identifier of the file.

2. **get-file-count**
   - Returns the total number of files stored.

3. **retrieve-file-count**
   - Fetches the current file count.

## Error Handling

The contract includes robust error handling to provide informative feedback for various scenarios:

- `error-file-not-found`: When a requested file does not exist.
- `error-file-exists`: When attempting to upload a file that already exists.
- `error-name-invalid`: For invalid file names.
- `error-size-invalid`: For files exceeding size limits.
- `error-not-authorized`: When a user tries to perform an action without proper authorization.
- `error-invalid-recipient`: For invalid user in permission settings.
- `error-access-denied`: When access is denied for a user.

## Usage

To interact with the Decentralized Storage System, deploy the contract on the Stacks blockchain and utilize the provided functions according to your requirements.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

For any questions or contributions, please feel free to reach out!
