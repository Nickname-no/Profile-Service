package com.titles.profileservice;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GreetingController {

    @Autowired
    private CustomerRepository repository;

    @GetMapping("/hello")
    public String hello() throws Exception  {

        String names = "";

        for (Customer customer : repository.findAll()) {
            names += customer.toString() + " ";
        }

        return "Hello " + names;
    }

    @GetMapping("/")
    public String test()  {
        return "Working";
    }

    @GetMapping("/setup")
    public String setup()  {
        repository.deleteAll();

        // save a couple of customers
        repository.save(new Customer("Alice", "Smith"));
        repository.save(new Customer("Bob", "Smith"));

        return "Setup done";
    }


}
