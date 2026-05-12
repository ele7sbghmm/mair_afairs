#include <App.h>

int main() {
	uWS::App()
		.get("/", [](auto* res, auto* req) {
			res->end("<h1>workin'</h1>");
		})
		.get("/data", [](auto* res, auto*req) {
			res->writeHeader("Content-Type", "application/json");
			res->end("{\"x\":1.,\"y\":2.}");
		})
		.ws<void*>("/live", {
			.open = [](auto* ws) {
				ws->subscribe("data");
			},
			.message = [](auto* ws, std::string_view msg, uWS::OpCode op) {
				ws->send(msg, op);
			}
		})
		.listen(9000, [](auto* token) {
			if (token)
	  			printf("listening on 9000");
		})
	  	.run();
}
