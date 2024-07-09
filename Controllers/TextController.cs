using Microsoft.AspNetCore.Mvc;

namespace TextAPI.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class TextController : ControllerBase
    {

        private readonly ILogger<TextController> _logger;

        public TextController(ILogger<TextController> logger)
        {
            _logger = logger;
        }

        [HttpGet("textToUpper")]
        public ActionResult<string> TextToUpper([FromQuery] string text)
        {
            if (string.IsNullOrEmpty(text))
            {
                return BadRequest("Query parameter 'text' is requiredsfsfsadasdas.");
            }

            return Ok(text.ToUpper());
        }

        [HttpGet("textToLower")]
        public ActionResult<string> TextToLower([FromQuery] string text)
        {
            if (string.IsNullOrEmpty(text))
            {
                return BadRequest("Query parameter 'text' is required.");
            }

            return Ok(text.ToLower());
        }
    }
}
