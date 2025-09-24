form.onsubmit = function(e){
    clearErrors();
    let isValid = true;
    if(!form['name'].value){
        display("name-error","name is required")
        isValid = false;
    }
    if(!form['email'].value){
        display("email-error","email is required");
        isValid = false;
    }
    
    const phoneRegex = /^[\d\s\-\+\(\)]{10,}$/;
    if (form['phone'].value.trim() && !phoneRegex.test(form['phone'].value.trim())) {
        display("phone-error", "Please enter a valid phone number");
        isValid = false;
    }
    
    if (!form['password'].value) {
        display("password-error", "Password is required");
        isValid = false;
    } else if (form['password'].value.length < 6) {
        display("password-error", "Password must be at least 6 characters long");
        isValid = false;
    }
    
    if (!form['confirm'].value) {
        display("confirm-error", "Please confirm your password");
        isValid = false;
    } else if (form['password'].value !== form['confirm'].value) {
        display("confirm-error", "Passwords do not match");
        isValid = false;
    }
    
    if (!isValid) {
        e.preventDefault();
        return false;
    }
    
    return isValid;
    
}