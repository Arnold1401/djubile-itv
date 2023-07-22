const errorHandler = (err, req, res, next) => {
  let code = 500;
  let msg = "Internal Server Error";

  if (err.name === "err_register") {
    code = 401;
    msg = "err_register" + "|" + err.message;
  } else if (err.name === "err_login") {
    code = 400;
    msg = err.message;
  } else if (err.name === "INVALID_TOKEN") {
    code = 401;
    msg = "INVALID_TOKEN";
  }

  res.status(code).json({
    statusCode: code,
    data: msg,
  });
};

module.exports = { errorHandler };
