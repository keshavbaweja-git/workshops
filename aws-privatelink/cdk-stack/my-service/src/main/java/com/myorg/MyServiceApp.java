package com.myorg;

import software.amazon.awscdk.App;
import software.amazon.awscdk.StackProps;


public class MyServiceApp {
    public static void main(final String[] args) {
        App app = new App();

        new MyServiceStack(app, "MyServiceStack", StackProps.builder()
                .build());

        app.synth();
    }
}

